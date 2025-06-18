import 'package:dartz/dartz.dart';
import '../repositories/home_repository.dart';

class UpdateHomeSettingsUseCase {
  final HomeRepository repository;

  UpdateHomeSettingsUseCase({required this.repository});

  Future<Either<Exception, void>> call(Map<String, dynamic> settings) async {
    return await repository.updateHomeSettings(settings);
  }
}
