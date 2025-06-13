// import '../dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';

import 'dio_client.dart';
import 'ehp_api.dart';

GetIt serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator.registerSingleton(Dio());
  serviceLocator.registerSingleton(DioClient(serviceLocator<Dio>()));
  // serviceLocator.registerSingleton(LineClient(Dio()));
  serviceLocator.registerSingleton(MOPHDioClient(Dio()));
  serviceLocator.registerSingleton(IDPDioClient(Dio()));
  serviceLocator.registerSingleton(PHRDioClient(Dio()));
  serviceLocator.registerSingleton(FCMDioClient(Dio()));
  serviceLocator.registerSingleton(EHPApi(dioClient: serviceLocator<DioClient>()));
  serviceLocator.registerSingleton<SocketErrorHandler>(SocketErrorHandler());
  serviceLocator.registerLazySingleton<SocketController>(() {
    final controller = SocketController();
    controller.initSocket(); // เรียก initSocket ที่นี่เลย
    return controller;
  });
  serviceLocator.registerLazySingleton(() => PillLineController());
  // serviceLocator.registerSingleton(
  // LineApi(dioClient : serviceLocator<LineClient>()));
}
