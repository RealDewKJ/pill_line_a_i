import 'package:dartz/dartz.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Exception, HomeData>> getHomeData() async {
    return await remoteDataSource.getHomeData();
  }

  @override
  Future<Either<Exception, void>> updateHomeSettings(Map<String, dynamic> settings) async {
    return await remoteDataSource.updateHomeSettings(settings);
  }
}
