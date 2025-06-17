import 'package:dartz/dartz.dart';
import '../entities/ex_notdata.dart';

abstract class ExNotDataRepository {
  Future<Either<Exception, ExNotData>> getExNotData();
  Future<Either<Exception, void>> updateExNotData(ExNotData data);
}
