import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../features/cattle_health/data/models/local/note_model.dart';
import '../../../navigation/navigator.dart';
import '../../custom_snack_bar.dart';
import '../../home_voice_note.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(const NoteState(null));

  final GlobalKey<HomeVoiceNoteState> voiceKey =
      GlobalKey<HomeVoiceNoteState>();
  final GlobalKey<FormBuilderState> textNoteKey = GlobalKey<FormBuilderState>();

  void onAddCattleVoiceNote() {
    final voice = voiceKey.currentState!;
    if (voice.isRecorded != false && voice.path != null) {
      final note = NoteModel(value: voice.path ?? '', type: NoteType.voice);
      emit(state.copyWith(noteValue: note));
      Go.back();
    } else {
      showSimpleToast(msg: LocaleKeys.pleaseRecordAudioFirst.tr());
    }
  }

  void onAddCattleTextNote() {
    final textNote = textNoteKey.currentState!;
    if (textNote.saveAndValidate()) {
      final note = NoteModel(
          value: textNote.fields['text_note']!.value, type: NoteType.text);
      Go.back();
      emit(state.copyWith(noteValue: note));
    }
  }

  void onRemoveVoiceNote() {
    emit(const NoteState(null));
  }

  void onRemoveVoiceFromBottomSheet() {
    final voice = voiceKey.currentState!;
    if (voice.isRecorded != false && voice.path != null) {
      voiceKey.currentState!.deleteRecord();
    }
  }
}
