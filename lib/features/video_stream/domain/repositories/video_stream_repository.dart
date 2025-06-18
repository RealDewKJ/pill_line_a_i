import 'dart:typed_data';
import '../entities/video_stream_entity.dart';
import '../entities/message_entity.dart';

abstract class VideoStreamService {
  Stream<Uint8List> get videoFrameStream;
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(String message);
  void configure({
    required Function(String) onMessage,
    required Function(bool) onConnectionStatusChanged,
  });
}

abstract class VideoStreamRepository {
  Stream<VideoStreamEntity> get videoStreamState;
  Stream<Uint8List> get videoFrameStream;
  Stream<MessageEntity> get messageStream;

  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(String message);

  void updateVideoState(VideoStreamEntity state);
  void handleMessage(MessageEntity message);
}
