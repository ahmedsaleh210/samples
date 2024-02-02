import 'dart:developer';

import 'package:cattle_management/src/core/shared/base_state.dart';
import 'package:cattle_management/src/features/dead_sheep/data/models/dead_sheep_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/dead_sheep_repository.dart';

part 'dead_sheep_state.dart';

class DeadSheepCubit extends Cubit<DeadSheepState> {
  final DeadSheepRepository _deadSheepRepository;
  DeadSheepCubit(this._deadSheepRepository) : super(DeadSheepState.empty());

  void getDeadSheep() async {
    log('test');

    emit(state.copyWith(status: BaseState.loading));
    final response = await _deadSheepRepository.getDeadSheep();
    response.when((success) {
      emit(state.copyWith(status: BaseState.success, deadSheepList: success));
    }, (error) {
      emit(state.copyWith(status: BaseState.error));
    });
  }
}
