import 'package:dartz/dartz.dart';
import '../../domain/entities/pill_line.dart';
import '../../domain/repositories/pill_line_repository.dart';
import '../datasources/pill_line_remote_data_source.dart';

class PillLineRepositoryImpl implements PillLineRepository {
  final PillLineRemoteDataSource remoteDataSource;

  PillLineRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, List<PillLine>>> getPillLines() async {
    try {
      final result = await remoteDataSource.getPillLines();
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, PillLine>> getPillLineById(String id) async {
    try {
      final result = await remoteDataSource.getPillLineById(id);
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> updatePillLineStatus(String id, String status) async {
    try {
      await remoteDataSource.updatePillLineStatus(id, status);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
