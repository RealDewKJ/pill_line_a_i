import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/dio_client.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/features/pill_line/data/datasources/pill_line_remote_data_source.dart';
import 'package:pill_line_a_i/features/pill_line/data/repositories/pill_line_repository_impl.dart';
import 'package:pill_line_a_i/features/pill_line/domain/repositories/pill_line_repository.dart';
import 'package:pill_line_a_i/features/pill_line/presentation/bloc/pill_line_bloc.dart';
import 'package:pill_line_a_i/features/not_found/presentation/bloc/not_found_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'package:pill_line_a_i/features/video_stream/core/di/video_stream_di.dart';
import 'package:pill_line_a_i/features/ex_notdata/core/di/ex_notdata_di.dart';
import 'package:pill_line_a_i/features/home/core/di/home_di.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Core services
  serviceLocator.registerSingleton(Dio());
  serviceLocator.registerSingleton(DioClient(serviceLocator<Dio>()));
  serviceLocator.registerSingleton(MOPHDioClient(Dio()));
  serviceLocator.registerSingleton(IDPDioClient(Dio()));
  serviceLocator.registerSingleton(PHRDioClient(Dio()));
  serviceLocator.registerSingleton(FCMDioClient(Dio()));
  serviceLocator.registerSingleton(EHPApi(dioClient: serviceLocator<DioClient>()));
  serviceLocator.registerSingleton<SocketErrorHandler>(SocketErrorHandler());

  // Controllers
  serviceLocator.registerLazySingleton<SocketController>(() {
    final controller = SocketController();
    // controller.initSocket();
    return controller;
  });

  // Data sources
  serviceLocator.registerLazySingleton<PillLineRemoteDataSource>(
    () => PillLineRemoteDataSourceImpl(),
  );

  // Repositories
  serviceLocator.registerLazySingleton<PillLineRepository>(
    () => PillLineRepositoryImpl(remoteDataSource: serviceLocator()),
  );

  // BLoCs
  serviceLocator.registerFactory(
    () => PillLineBloc(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => NotFoundBloc(),
  );
  serviceLocator.registerFactory(
    () => ExNotDataBloc(repository: serviceLocator()),
  );

  // Setup VideoStream dependencies
  VideoStreamDI.setup();

  // Setup ExNotData dependencies
  ExNotDataDI.init();

  // Setup Home dependencies
  setupHomeDI(serviceLocator);
}
