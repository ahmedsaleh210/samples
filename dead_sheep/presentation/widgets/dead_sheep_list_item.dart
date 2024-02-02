part of 'dead_sheep_widgets_imports.dart';

class DeadSheepListItem extends StatelessWidget {
  final DeadSheepModel deadSheepModel;
  const DeadSheepListItem({super.key, required this.deadSheepModel});

  @override
  Widget build(BuildContext context) {
    return DefaultCattleCard(
      children: [
        CattleCardHeader(
          trailingText: 'Died on:',
          trailingValue: deadSheepModel.deathDate,
          age: deadSheepModel.age,
        ),
        CattleCardInfo(
          id: deadSheepModel.id,
          descrition: deadSheepModel.description,
          status: deadSheepModel.status,
          statusColor: AppColors.redBackground,
        ),
        DeathCauseItem(
          deathCause: deadSheepModel.cause,
          isRecord: deadSheepModel.isRecord,
        ),
      ],
    );
  }
}
