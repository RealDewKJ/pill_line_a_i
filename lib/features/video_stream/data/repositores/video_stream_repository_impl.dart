import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:pill_line_a_i/features/video_stream/domain/entities/message_entity.dart';
import 'package:pill_line_a_i/features/video_stream/domain/entities/video_stream_entity.dart';
import 'package:pill_line_a_i/features/video_stream/domain/repositories/video_stream_repository.dart';

import '../services/video_stream_service_impl.dart';

class VideoStreamRepositoryImpl implements VideoStreamRepository {
  final VideoStreamService _videoStreamService;
  final StreamController<VideoStreamEntity> _videoStateController = StreamController<VideoStreamEntity>.broadcast();
  final StreamController<MessageEntity> _messageController = StreamController<MessageEntity>.broadcast();

  VideoStreamEntity _currentState = const VideoStreamEntity();

  VideoStreamRepositoryImpl(this._videoStreamService);

  @override
  Stream<VideoStreamEntity> get videoStreamState => _videoStateController.stream;

  @override
  Stream<Uint8List> get videoFrameStream => _videoStreamService.videoFrameStream;

  @override
  Stream<MessageEntity> get messageStream => _messageController.stream;

  @override
  Future<void> connect() async {
    await _videoStreamService.connect();
    _updateState(_currentState.copyWith(isConnected: true));
  }

  @override
  Future<void> disconnect() async {
    await _videoStreamService.disconnect();
    _updateState(_currentState.copyWith(isConnected: false));
  }

  @override
  Future<void> sendMessage(String message) async {
    await _videoStreamService.sendMessage(message);
  }

  @override
  void updateVideoState(VideoStreamEntity state) {
    _currentState = state;
    _videoStateController.add(state);
  }

  @override
  void handleMessage(MessageEntity message) {
    _messageController.add(message);
  }

  void _updateState(VideoStreamEntity newState) {
    _currentState = newState;
    _videoStateController.add(newState);
  }

  void dispose() {
    _videoStateController.close();
    _messageController.close();
  }
}
