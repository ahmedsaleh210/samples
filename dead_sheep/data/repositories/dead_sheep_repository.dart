import 'package:cattle_management/src/core/error/failure.dart';
import 'package:cattle_management/src/core/extensions/error_handler_extension.dart';
import 'package:cattle_management/src/features/dead_sheep/data/models/dead_sheep_model.dart';
import 'package:multiple_result/multiple_result.dart';

class DeadSheepRepository {
  Future<Result<List<DeadSheepModel>, ServerFailure>> getDeadSheep() async {
    final response = await Future.value([
      ...List.generate(
        10,
        (index) => DeadSheepModel(
            age: 25,
            id: '2254',
            deathDate: '26 Jun, 23',
            status: 'Dead',
            cause:
                'This sheep was suffering with fever for some time and it make him sick.',
            description: 'Male I Born in Farm',
            isRecord: false),
      ),
      DeadSheepModel(
          age: 25,
          id: '2254',
          deathDate: '26 Jun, 23',
          status: 'Dead',
          cause: 'https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav',
          description: 'Male I Born in Farm',
          isRecord: true)
    ]).handleCallbackWithFailure();
    return response;
  }
}
