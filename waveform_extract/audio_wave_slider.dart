import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cattle_management/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../utils/app_colors.dart';

enum AudioType { network, local }

class AudioWaveFormSlider extends StatefulWidget {
  final String path;
  final AudioType type;
  final double contentMargin;
  final double iconsSize;
  final Size? size;
  final VoidCallback? removeCallBack;

  const AudioWaveFormSlider(
      {super.key,
      required this.path,
      required this.type,
      this.size,
      this.iconsSize = 30,
      this.removeCallBack,
      this.contentMargin = 10});

  @override
  State<AudioWaveFormSlider> createState() => _AudioWaveFormSliderState();
}

class _AudioWaveFormSliderState extends State<AudioWaveFormSlider> {
  late PlayerController _controller;
  late StreamSubscription<PlayerState> playerStateSubscription;
  bool _isPlayed = false;
  bool _isLoading = true;

  @override
  void initState() {
    _controller = PlayerController();
    _init();
    playerStateSubscription = _controller.onPlayerStateChanged.listen((state) {
      log('state is $state');
      if (state == PlayerState.initialized) {
        log('initialized');
        setState(() {
          _isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.stopPlayer();
    _controller.dispose();
    playerStateSubscription.cancel();
    super.dispose();
  }

  Future<String> _getNetworkAudio() async {
    final uri = Uri.parse(widget.path);
    final audioFile =
        File(p.join((await getTemporaryDirectory()).path, 'waveform.mp3'));
    final fileAudio = await audioFile.writeAsBytes(
        (await NetworkAssetBundle(uri).load(uri.toString()))
            .buffer
            .asUint8List());
    return fileAudio.path;
  }

  Future<void> _init() async {
    try {
      String audio = '';
      if (widget.type == AudioType.network) {
        audio = await _getNetworkAudio();
        log('audio is $audio');
      } else {
        audio = widget.path;
        log('audio is $audio');
      }
      await _controller.preparePlayer(
        path: audio,
        shouldExtractWaveform: true,
        noOfSamples: playerWaveStyle
            .getSamplesForWidth(0.7.sw - widget.contentMargin.w * 2),
        volume: 1.0,
      );
    } on PlatformException catch (e) {
      debugPrint('Error: $e');
    }
  }

  final playerWaveStyle = PlayerWaveStyle(
      fixedWaveColor: Colors.grey,
      liveWaveColor: AppColors.primary,
      seekLineColor: AppColors.primary,
      scaleFactor: 200,
      showSeekLine: false,
      waveThickness: 1,
      spacing: 2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.contentMargin.w),
      child: _isLoading
          ? Center(
              child: SpinKitWave(
                color: AppColors.primary,
                size: 30.r,
                itemCount: 7,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AudioFileWaveforms(
                    playerController: _controller,
                    size: widget.size ??
                        Size(0.7.sw - widget.contentMargin.w, 35.h),
                    waveformType: WaveformType.fitWidth,
                    playerWaveStyle: playerWaveStyle),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (_isPlayed) {
                      _controller.pausePlayer();
                    } else {
                      _controller.startPlayer(
                        finishMode: FinishMode.loop,
                      );
                    }
                    setState(() {
                      _isPlayed = !_isPlayed;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: AppColors.greyBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Icon(
                      size: widget.iconsSize.sp,
                      color: Colors.black,
                      _isPlayed ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                ),
                if (widget.removeCallBack != null) ...{
                  5.szW,
                  InkWell(
                    onTap: widget.removeCallBack,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        border: Border.all(color: Colors.grey[300]!),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                          size: widget.iconsSize.sp,
                          color: Colors.red,
                          Icons.delete),
                    ),
                  ),
                }
              ],
            ),
    );
  }
}
