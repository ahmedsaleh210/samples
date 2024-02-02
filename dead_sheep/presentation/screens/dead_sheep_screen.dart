import 'dart:developer';

import 'package:cattle_management/src/features/cattle/presentation/widgets/cattle_widgets_imports.dart';
import 'package:cattle_management/src/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared/base_state.dart';
import '../cubit/dead_sheep_cubit.dart';
import '../widgets/dead_sheep_widgets_imports.dart';

class DeadSheepScreen extends StatelessWidget {
  const DeadSheepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<DeadSheepCubit>()..getDeadSheep(),
      child: const DeadSheepView(),
    );
  }
}

class DeadSheepView extends StatelessWidget {
  const DeadSheepView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CattleAppBar(
        title: 'Dead Cattle',
        hasBack: true,
        hasFilter: false,
      ),
      body: BlocBuilder<DeadSheepCubit, DeadSheepState>(
        builder: (context, state) {
          log('test state ${state.status}');
          switch (state.status) {
            case BaseState.initial:
            case BaseState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case BaseState.success:
            case BaseState.error:
              return ListView.builder(
                itemBuilder: ((context, index) => DeadSheepListItem(
                      deadSheepModel: state.deadSheepList[index],
                    )),
                itemCount: state.deadSheepList.length,
              );
          }
        },
      ),
    );
  }
}
