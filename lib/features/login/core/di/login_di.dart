import 'package:get_it/get_it.dart';
import 'package:pill_line_a_i/features/login/presentation/bloc/login_bloc.dart';
import 'package:pill_line_a_i/features/login/data/datasources/login_remote_data_source.dart';
import 'package:pill_line_a_i/features/login/data/repositories/login_repository_impl.dart';
import 'package:pill_line_a_i/features/login/domain/repositories/login_repository.dart';
import 'package:pill_line_a_i/features/login/domain/usecases/login_usecase.dart';
import 'package:dio/dio.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';

class LoginDI {
  static final GetIt _getIt = GetIt.instance;

  static void init() {
    // Data Source
    _getIt.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSource(ehpApi: _getIt<EHPApi>()),
    );
    // Repository
    _getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(remoteDataSource: _getIt<LoginRemoteDataSource>()),
    );
    // Use Case
    _getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(repository: _getIt<LoginRepository>()),
    );
    // Bloc
    _getIt.registerFactory(
      () => LoginBloc(loginUseCase: _getIt<LoginUseCase>()),
    );
  }

  static void dispose() {
    try {
      _getIt.unregister<LoginRemoteDataSource>();
      _getIt.unregister<LoginRepository>();
      _getIt.unregister<LoginUseCase>();
      _getIt.unregister<LoginBloc>();
    } catch (e) {
      // Ignore errors if dependencies are not registered
    }
  }
}
