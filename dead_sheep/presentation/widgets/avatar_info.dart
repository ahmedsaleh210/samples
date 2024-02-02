part of 'dead_sheep_widgets_imports.dart';

class AvatarInfo extends StatelessWidget {
  final DeadSheepModel deadSheepModel;
  const AvatarInfo({super.key, required this.deadSheepModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomAvatar(icon: SvgAssets.sheep),
        10.szW,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const StatusIcon(),
                5.szW,
                AppText(deadSheepModel.id, fontSize: 14.sp),
              ],
            ),
            5.szW,
            AppText('Male I Born in Farm', fontSize: 12.sp),
          ],
        ),
        const Spacer(),
        StatusText(
          text: deadSheepModel.status,
          color: AppColors.redBackground,
        )
      ],
    );
  }
}
