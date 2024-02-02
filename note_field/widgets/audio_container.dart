part of 'note_sheet_imports.dart';

class AudioContainer extends StatelessWidget {
  final String path;
  final VoidCallback removeCallBack;
  final AudioType? type;
  const AudioContainer(
      {super.key,
      required this.path,
      required this.removeCallBack,
      this.type = AudioType.local});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
          color: AppColors.greyBackground,
          borderRadius: BorderRadius.circular(10.r)),
      child: AudioWaveFormSlider(
        path: path,
        contentMargin: 15,
        removeCallBack: removeCallBack,
        size: Size(0.48.sw, 35.h),
        type: AudioType.local,
        iconsSize: 20,
      ),
    );
  }
}
