part of 'dead_sheep_widgets_imports.dart';

class DeathCauseItem extends StatelessWidget {
  final String deathCause;
  final bool isRecord;
  const DeathCauseItem({
    super.key,
    required this.deathCause,
    required this.isRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: AppColors.greyBorder.withOpacity(0.2)),
        ),
        child: isRecord
            ? AudioWaveFormSlider(
                path: deathCause,
                type: AudioType.network,
              )
            : AppText(deathCause));
  }
}
