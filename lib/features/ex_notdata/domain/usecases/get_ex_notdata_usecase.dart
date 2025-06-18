import 'package:dartz/dartz.dart';
import '../entities/ex_notdata.dart';
import '../repositories/ex_notdata_repository.dart';

class GetExNotDataUseCase {
  final ExNotDataRepository repository;

  GetExNotDataUseCase(this.repository);

  Future<Either<Exception, ExNotData>> call() async {
    return await repository.getExNotData();
  }
}
