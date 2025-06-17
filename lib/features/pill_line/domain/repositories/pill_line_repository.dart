import 'package:dartz/dartz.dart';
import '../entities/pill_line.dart';

abstract class PillLineRepository {
  Future<Either<Exception, List<PillLine>>> getPillLines();
  Future<Either<Exception, PillLine>> getPillLineById(String id);
  Future<Either<Exception, void>> updatePillLineStatus(String id, String status);
}
