part of 'note_sheet_imports.dart';

class TextNoteBottomSheet extends StatefulWidget {
  final VoidCallback onSave;
  final GlobalKey<FormBuilderState> formKey;
  const TextNoteBottomSheet(
      {super.key, required this.onSave, required this.formKey});

  @override
  State<TextNoteBottomSheet> createState() => _TextNoteBottomSheetState();
}

class _TextNoteBottomSheetState extends State<TextNoteBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DefaultBottomSheetSkelton(
          children: [
            const GreyBottomSheetDivider(),
            30.szH,
            AppText(LocaleKeys.addNote.tr(),
                fontWeight: FontWeight.w700, fontSize: 18.sp),
            40.szH,
            FormBuilder(
              key: widget.formKey,
              child: DefaultTextField(
                inputType: TextInputType.multiline,
                maxLines: 5,
                validator: Validators.validateEmpty,
                borderColor: AppColors.dark5,
                closeWhenTapOutSide: false,
                name: 'text_note',
              ),
            ),
            Column(
              children: [
                10.szH,
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: SaveButton(onTap: widget.onSave),
                ),
              ],
            )
          ],
        ));
  }
}
