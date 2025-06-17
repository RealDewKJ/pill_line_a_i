import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/dio_client.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/features/pill_line/data/datasources/pill_line_remote_data_source.dart';
import 'package:pill_line_a_i/features/pill_line/data/repositories/pill_line_repository_impl.dart';
import 'package:pill_line_a_i/features/pill_line/domain/repositories/pill_line_repository.dart';
import 'package:pill_line_a_i/features/pill_line/presentation/bloc/pill_line_bloc.dart';
import 'package:pill_line_a_i/features/home/presentation/bloc/home_bloc.dart';
import 'package:pill_line_a_i/features/not_found/presentation/bloc/not_found_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/data/datasources/ex_notdata_remote_data_source.dart';
import 'package:pill_line_a_i/features/ex_notdata/data/repositories/ex_notdata_repository_impl.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/repositories/ex_notdata_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Core services
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(MOPHDioClient(Dio()));
  getIt.registerSingleton(IDPDioClient(Dio()));
  getIt.registerSingleton(PHRDioClient(Dio()));
  getIt.registerSingleton(FCMDioClient(Dio()));
  getIt.registerSingleton(EHPApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton<SocketErrorHandler>(SocketErrorHandler());

  // Controllers
  getIt.registerLazySingleton<SocketController>(() {
    final controller = SocketController();
    controller.initSocket();
    return controller;
  });
  getIt.registerLazySingleton(() => PillLineController());

  // Data sources
  getIt.registerLazySingleton<PillLineRemoteDataSource>(
    () => PillLineRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<ExNotDataRemoteDataSource>(
    () => ExNotDataRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<PillLineRepository>(
    () => PillLineRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ExNotDataRepository>(
    () => ExNotDataRepositoryImpl(remoteDataSource: getIt()),
  );

  // BLoCs
  getIt.registerFactory(
    () => PillLineBloc(repository: getIt()),
  );
  getIt.registerFactory(
    () => HomeBloc(repository: getIt()),
  );
  getIt.registerFactory(
    () => NotFoundBloc(),
  );
  getIt.registerFactory(
    () => ExNotDataBloc(repository: getIt()),
  );
}
