import 'package:dartz/dartz.dart';
import '../../domain/entities/ex_notdata.dart';
import '../../domain/repositories/ex_notdata_repository.dart';
import '../datasources/ex_notdata_remote_data_source.dart';

class ExNotDataRepositoryImpl implements ExNotDataRepository {
  final ExNotDataRemoteDataSource remoteDataSource;

  ExNotDataRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, ExNotData>> getExNotData() async {
    try {
      final result = await remoteDataSource.getExNotData();
      return Right(result);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> updateExNotData(ExNotData data) async {
    try {
      await remoteDataSource.updateExNotData(data);
      return const Right(null);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
