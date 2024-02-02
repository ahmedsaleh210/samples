import 'package:equatable/equatable.dart';

import '../../../../features/cattle_health/data/models/local/note_model.dart';

final class NoteState extends Equatable {
  final NoteModel? noteValue;
  const NoteState(this.noteValue);

  NoteState copyWith({
    NoteModel? noteValue,
  }) {
    return NoteState(
      noteValue ?? this.noteValue,
    );
  }

  @override
  List<Object?> get props => [noteValue];
}
