import 'package:dartz/dartz.dart';
import '../entities/home_data.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase({required this.repository});

  Future<Either<Exception, HomeData>> call() async {
    return await repository.getHomeData();
  }
}
