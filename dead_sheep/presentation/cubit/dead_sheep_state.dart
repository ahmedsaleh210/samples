part of 'dead_sheep_cubit.dart';

class DeadSheepState extends Equatable {
  final BaseState status;
  final List<DeadSheepModel> deadSheepList;

  const DeadSheepState({
    required this.status,
    required this.deadSheepList,
  });
  factory DeadSheepState.empty() {
    return const DeadSheepState(
      status: BaseState.initial,
      deadSheepList: [],
    );
  }

  DeadSheepState copyWith({
    BaseState? status,
    List<DeadSheepModel>? deadSheepList,
  }) {
    return DeadSheepState(
      status: status ?? this.status,
      deadSheepList: deadSheepList ?? this.deadSheepList,
    );
  }

  @override
  List<Object> get props => [
    status,
    deadSheepList,
  ];
}
