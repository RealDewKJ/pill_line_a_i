import '../datasources/login_remote_data_source.dart';
import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  LoginRepositoryImpl({required this.remoteDataSource});
}
