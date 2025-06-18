import 'package:pill_line_a_i/features/video_stream/domain/repositories/video_stream_repository.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/services/video_stream_service_impl.dart';
import '../../data/repositores/video_stream_repository_impl.dart';
import '../../domain/usecases/video_stream_usecase.dart';

class VideoStreamDI {
  static void setup() {
    serviceLocator.registerLazySingleton<VideoStreamServiceImpl>(
      () => VideoStreamServiceImpl(),
    );

    // Register VideoStreamRepository
    serviceLocator.registerLazySingleton<VideoStreamRepository>(
      () => VideoStreamRepositoryImpl(serviceLocator<VideoStreamServiceImpl>()),
    );

    // Register VideoStreamUseCase
    serviceLocator.registerLazySingleton<VideoStreamUseCase>(
      () => VideoStreamUseCase(serviceLocator<VideoStreamRepository>()),
    );
  }

  static VideoStreamUseCase getVideoStreamUseCase() {
    return serviceLocator<VideoStreamUseCase>();
  }
}
