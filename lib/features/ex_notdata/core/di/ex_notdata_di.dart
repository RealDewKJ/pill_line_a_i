import 'package:get_it/get_it.dart';
import '../../data/datasources/ex_notdata_remote_data_source.dart';
import '../../data/repositories/ex_notdata_repository_impl.dart';
import '../../domain/repositories/ex_notdata_repository.dart';
import '../../domain/usecases/get_ex_notdata_usecase.dart';
import '../../domain/usecases/update_ex_notdata_usecase.dart';
import '../../data/services/ex_notdata_websocket_service.dart';
import '../../data/services/ex_notdata_navigation_service.dart';
import '../../data/services/ex_notdata_message_handler.dart';

class ExNotDataDI {
  static final GetIt _getIt = GetIt.instance;

  static void reset() {
    try {
      _getIt.reset();
    } catch (e) {
      // Ignore errors if nothing is registered
    }
  }

  static void init() {
    // Reset first to ensure clean state
    reset();

    // Data Sources
    _getIt.registerLazySingleton<ExNotDataRemoteDataSource>(
      () => ExNotDataRemoteDataSourceImpl(),
    );

    // Repositories
    _getIt.registerLazySingleton<ExNotDataRepository>(
      () => ExNotDataRepositoryImpl(
        remoteDataSource: _getIt<ExNotDataRemoteDataSource>(),
      ),
    );

    // Use Cases
    _getIt.registerLazySingleton<GetExNotDataUseCase>(
      () => GetExNotDataUseCase(_getIt<ExNotDataRepository>()),
    );

    _getIt.registerLazySingleton<UpdateExNotDataUseCase>(
      () => UpdateExNotDataUseCase(_getIt<ExNotDataRepository>()),
    );

    // Services
    _getIt.registerLazySingleton<ExNotDataWebSocketService>(
      () => ExNotDataWebSocketService(),
    );

    _getIt.registerLazySingleton<ExNotDataNavigationService>(
      () => ExNotDataNavigationService(),
    );

    _getIt.registerLazySingleton<ExNotDataMessageHandler>(
      () => ExNotDataMessageHandler(_getIt<ExNotDataNavigationService>()),
    );
  }

  // Getters
  static ExNotDataRepository get repository => _getIt<ExNotDataRepository>();
  static GetExNotDataUseCase get getExNotDataUseCase => _getIt<GetExNotDataUseCase>();
  static UpdateExNotDataUseCase get updateExNotDataUseCase => _getIt<UpdateExNotDataUseCase>();
  static ExNotDataWebSocketService get webSocketService => _getIt<ExNotDataWebSocketService>();
  static ExNotDataNavigationService get navigationService => _getIt<ExNotDataNavigationService>();
  static ExNotDataMessageHandler get messageHandler => _getIt<ExNotDataMessageHandler>();

  static void dispose() {
    try {
      _getIt.unregister<ExNotDataRepository>();
      _getIt.unregister<GetExNotDataUseCase>();
      _getIt.unregister<UpdateExNotDataUseCase>();
      _getIt.unregister<ExNotDataWebSocketService>();
      _getIt.unregister<ExNotDataNavigationService>();
      _getIt.unregister<ExNotDataMessageHandler>();
    } catch (e) {
      // Ignore errors if dependencies are not registered
    }
  }
}
