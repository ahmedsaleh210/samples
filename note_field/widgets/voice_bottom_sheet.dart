part of 'note_sheet_imports.dart';

class VoiceBottomSheet extends StatelessWidget {
  final VoidCallback onSave;
  const VoiceBottomSheet({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DefaultBottomSheetSkelton(
          hasPadding: false,
          children: [
            const GreyBottomSheetDivider().paddingTop(10.h),
            15.szH,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.recordVoice.tr(),
                    fontWeight: FontWeight.w700, fontSize: 18.sp),
                15.szH,
                HomeVoiceNote(
                  key: context.read<NoteCubit>().voiceKey,
                ),
              ],
            ).paddingSymmetric(horizontal: 20.w, vertical: 10.h),
            Divider(
              height: 30.h,
              color: Colors.grey[300],
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _AudioControllerIcons(),
                SaveButton(onTap: onSave),
              ],
            ).paddingSymmetric(horizontal: 20.w, vertical: 10.h)
          ],
        ));
  }
}

class _AudioControllerIcons extends StatelessWidget {
  const _AudioControllerIcons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: context.read<NoteCubit>().onRemoveVoiceFromBottomSheet,
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.grey[100], shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: Colors.red)),
        ),
        // 10.szW,
        // InkWell(
        //   onTap: () {},
        //   child: Container(
        //       padding: const EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //           color: Colors.grey[100], shape: BoxShape.circle),
        //       child: const Icon(Icons.pause_outlined, color: Colors.black)),
        // ),
      ],
    );
  }
}
