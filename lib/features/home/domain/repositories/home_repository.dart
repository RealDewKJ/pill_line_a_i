import 'package:dartz/dartz.dart';
import '../entities/home_data.dart';

abstract class HomeRepository {
  Future<Either<Exception, HomeData>> getHomeData();
  Future<Either<Exception, void>> updateHomeSettings(Map<String, dynamic> settings);
}
