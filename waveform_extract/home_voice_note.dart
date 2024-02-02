import 'dart:developer';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cattle_management/src/core/extensions/sized_box_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/app_colors.dart';

class HomeVoiceNote extends StatefulWidget {
  const HomeVoiceNote({super.key});

  @override
  State<HomeVoiceNote> createState() => HomeVoiceNoteState();
}

class HomeVoiceNoteState extends State<HomeVoiceNote> {
  String? path;
  bool isRecording = false;
  bool firstRecord = false;
  bool isLoading = true;
  bool isRecorded = false;
  late Directory appDirectory;
  bool isPlaying = false;

  late final RecorderController recorderController;
  late final PlayerController playerController;

  final PlayerWaveStyle playerWaveStyle = PlayerWaveStyle(
      fixedWaveColor: AppColors.dark5,
      liveWaveColor: AppColors.primary,
      seekLineColor: AppColors.dark5,
      scaleFactor: 200,
      showSeekLine: false,
      spacing: 2,
      waveThickness: 1);

  final WaveStyle waveStyle = WaveStyle(
      waveColor: AppColors.primary,
      extendWaveform: true,
      scaleFactor: 40,
      spacing: 2,
      waveThickness: 1,
      showMiddleLine: false);

  void _initialiseControllers() {
    playerController = PlayerController();
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  Future<void> _init() async {
    try {
      await playerController.preparePlayer(
          path: path!, shouldExtractWaveform: true, volume: 1.0);
      playerController.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.initialized) {
          setState(() {});
        }
      }); // Listening to audio completion
    } on PlatformException catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _startOrStopRecording() async {
    playerController.stopPlayer();
    try {
      if (isRecording) {
        recorderController.reset();
        final path = await recorderController.stop(false);
        if (path != null) _init();
        isRecorded = true;
      } else {
        await recorderController.record(path: path!);
      }
      firstRecord = true;
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDir();
    _initialiseControllers();
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    isLoading = false;
    setState(() {});
  }

  void _playAndPause() async {
    playerController.playerState == PlayerState.playing
        ? await playerController.pausePlayer()
        : playerController.startPlayer(
            finishMode: FinishMode.pause, forceRefresh: true);
    isPlaying = !isPlaying;
    setState(() {});
  }

  void deleteRecord() {
    playerController.stopPlayer();
    recorderController.reset();
    setState(() {
      isRecorded = false;
      firstRecord = false;
    });
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.dark1),
                  borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                children: [
                  Container(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                        color: isRecording
                            ? AppColors.primaryLigh2
                            : AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(22.5.r)),
                    child: IconButton(
                        onPressed: _startOrStopRecording,
                        icon: const Icon(Icons.mic),
                        color: isRecording
                            ? AppColors.white
                            : AppColors.primaryLigh2,
                        iconSize: 25),
                  ),
                  8.szW,
                  if (!isRecording && isRecorded)
                    Container(
                      width: 45.w,
                      height: 45.w,
                      decoration: BoxDecoration(
                          color: isPlaying
                              ? AppColors.primaryLigh2
                              : AppColors.greyBackground,
                          borderRadius: BorderRadius.circular(22.5.r)),
                      child: IconButton(
                          onPressed: _playAndPause,
                          icon:
                              Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                          color: isPlaying
                              ? AppColors.white
                              : AppColors.primaryLigh2,
                          iconSize: 25),
                    ),
                  AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isRecording
                          ? AudioWaveforms(
                              size: Size(
                                  MediaQuery.of(context).size.width / 2, 50),
                              recorderController: recorderController,
                              enableGesture: true,
                              waveStyle: waveStyle)
                          : isRecorded
                              ? AudioFileWaveforms(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
                                  continuousWaveform: true,
                                  enableSeekGesture: true,
                                  margin: EdgeInsets.zero,
                                  size: Size(
                                      MediaQuery.of(context).size.width / 2.4,
                                      50),
                                  playerController: playerController,
                                  playerWaveStyle: playerWaveStyle)
                              : null),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
