import 'package:dartz/dartz.dart';
import '../entities/ex_notdata.dart';
import '../repositories/ex_notdata_repository.dart';

class UpdateExNotDataUseCase {
  final ExNotDataRepository repository;

  UpdateExNotDataUseCase(this.repository);

  Future<Either<Exception, void>> call(ExNotData data) async {
    return await repository.updateExNotData(data);
  }
}
