import 'package:get_it/get_it.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../domain/usecases/update_home_settings_usecase.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../presentation/bloc/pill_line_bloc.dart';

void setupHomeDI(GetIt getIt) {
  // Data sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton<GetHomeDataUseCase>(
    () => GetHomeDataUseCase(
      repository: getIt<HomeRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateHomeSettingsUseCase>(
    () => UpdateHomeSettingsUseCase(
      repository: getIt<HomeRepository>(),
    ),
  );

  // BLoCs
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      getHomeDataUseCase: getIt<GetHomeDataUseCase>(),
      updateHomeSettingsUseCase: getIt<UpdateHomeSettingsUseCase>(),
    ),
  );

  getIt.registerFactory<PillLineBloc>(
    () => PillLineBloc(
      socketController: getIt<SocketController>(),
    ),
  );
}
