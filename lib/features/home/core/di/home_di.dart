import 'package:get_it/get_it.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../domain/usecases/update_home_settings_usecase.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/pill_line_bloc.dart';

class HomeDI {
  static final GetIt _getIt = GetIt.instance;

  static void init() {
    // Data sources
    _getIt.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(),
    );

    // Repositories
    _getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        remoteDataSource: _getIt<HomeRemoteDataSource>(),
      ),
    );

    // Use cases
    _getIt.registerLazySingleton<GetHomeDataUseCase>(
      () => GetHomeDataUseCase(
        repository: _getIt<HomeRepository>(),
      ),
    );

    _getIt.registerLazySingleton<UpdateHomeSettingsUseCase>(
      () => UpdateHomeSettingsUseCase(
        repository: _getIt<HomeRepository>(),
      ),
    );

    // BLoCs
    _getIt.registerFactory<HomeBloc>(
      () => HomeBloc(
        getHomeDataUseCase: _getIt<GetHomeDataUseCase>(),
        updateHomeSettingsUseCase: _getIt<UpdateHomeSettingsUseCase>(),
      ),
    );

    _getIt.registerFactory<PillLineBloc>(
      () => PillLineBloc(
        socketController: _getIt<SocketController>(),
      ),
    );
  }

  static void dispose() {
    try {
      _getIt.unregister<HomeRemoteDataSource>();
      _getIt.unregister<HomeRepository>();
      _getIt.unregister<GetHomeDataUseCase>();
      _getIt.unregister<UpdateHomeSettingsUseCase>();
      _getIt.unregister<HomeBloc>();
      _getIt.unregister<PillLineBloc>();
    } catch (e) {
      // Ignore errors if dependencies are not registered
    }
  }
}
