import 'dart:typed_data';
import 'dart:ui';
import '../entities/video_stream_entity.dart';
import '../entities/message_entity.dart';
import '../repositories/video_stream_repository.dart';

class VideoStreamUseCase {
  final VideoStreamRepository repository;

  VideoStreamUseCase(this.repository);

  Stream<VideoStreamEntity> get videoStreamState => repository.videoStreamState;
  Stream<Uint8List> get videoFrameStream => repository.videoFrameStream;
  Stream<MessageEntity> get messageStream => repository.messageStream;

  Future<void> connectToStream() async {
    await repository.connect();
  }

  Future<void> disconnectFromStream() async {
    await repository.disconnect();
  }

  Future<void> sendMessage(String message) async {
    await repository.sendMessage(message);
  }

  void updateVideoScale(double scale) {
    final currentState = _getCurrentState();
    final newState = currentState.copyWith(
      scale: scale,
      isZoomed: scale > 1.0,
    );
    repository.updateVideoState(newState);
  }

  void updateVideoPosition(double x, double y) {
    final currentState = _getCurrentState();
    final newState = currentState.copyWith(
      position: Offset(x, y),
    );
    repository.updateVideoState(newState);
  }

  void toggleVideoVisibility() {
    final currentState = _getCurrentState();
    final newState = currentState.copyWith(
      isVisible: !currentState.isVisible,
    );
    repository.updateVideoState(newState);
  }

  void handleIncomingMessage(String message) {
    final messageEntity = MessageEntity.fromSocketMessage(message);
    repository.handleMessage(messageEntity);
  }

  VideoStreamEntity _getCurrentState() {
    // This would typically get the current state from the repository
    // For now, return a default state
    return const VideoStreamEntity();
  }
}
