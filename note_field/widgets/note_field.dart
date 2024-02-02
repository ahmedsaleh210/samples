part of 'note_sheet_imports.dart';

class NoteField extends StatelessWidget {
  final Function(NoteModel? note)? onSave;
  const NoteField({super.key, this.onSave});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteCubit(),
      child: BlocConsumer<NoteCubit, NoteState>(
          listener: (context, state) {},
          builder: (context, state) {
            final cubit = context.read<NoteCubit>();
            final note = state.noteValue;
            log('note $note');
            if (note == null) {
              return DefaultTextField(
                inputType: TextInputType.text,
                name: 'reason',
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<NoteCubit>(context),
                            child: TextNoteBottomSheet(
                              formKey: cubit.textNoteKey,
                              onSave: () {
                                cubit.onAddCattleTextNote();
                                if (onSave != null) {
                                  onSave!(cubit.state.noteValue);
                                }
                              },
                            ),
                          ));
                },
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<NoteCubit>(context),
                              child: VoiceBottomSheet(
                                onSave: () {
                                  cubit.onAddCattleVoiceNote();
                                   if (onSave != null) {
                                    onSave!(cubit.state.noteValue);
                                  }
                                },
                              ),
                            ));
                  },
                  icon: Padding(
                    padding: EdgeInsets.all(16.0.sp),
                    child: SvgPicture.asset(SvgAssets.record),
                  ),
                ),
                validator: Validators.validateEmpty,
                title: LocaleKeys.addVoiceOrTextNote.tr(),
              );
            } else {
              return switch (note.type) {
                NoteType.voice => AudioContainer(
                    path: note.value,
                    removeCallBack: () {
                      context.read<NoteCubit>().onRemoveVoiceNote();
                    }),
                NoteType.text => Container(
                    padding: EdgeInsets.all(12.0.sp),
                    decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: AppText(note.value))
              };
            }
          }),
    );
  }
}
