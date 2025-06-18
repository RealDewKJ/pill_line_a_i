import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import '../../domain/repositories/video_stream_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoStreamServiceImpl implements VideoStreamService {
  WebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;
  StreamController<Uint8List> _videoFrameController = StreamController<Uint8List>.broadcast();
  bool _isConnected = false;
  Function(String)? _onMessage;
  Function(bool)? _onConnectionStatusChanged;

  @override
  Stream<Uint8List> get videoFrameStream => _videoFrameController.stream;

  @override
  Future<void> connect() async {
    log('Connecting to WebSocket... Current status: $_isConnected');
    if (_isConnected) {
      log('Already connected, skipping...');
      return;
    }

    // ปิดการเชื่อมต่อเก่าก่อนเริ่มใหม่ (ถ้ามี)
    if (_channel != null) {
      await disconnect();
    }

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.50.177:6789/ws/video-stream'),
      );

      _streamSubscription = _channel!.stream.listen(
        (message) {
          try {
            if (message is String) {
              final json = jsonDecode(message);
              _handleMessage(json);
            } else if (message is List<int>) {
              if (!_videoFrameController.isClosed) {
                _videoFrameController.add(Uint8List.fromList(message));
              }
            }
          } catch (e) {
            log('Error processing message: $e');
            _onMessage?.call('Error processing message: $e');
          }
        },
        onError: (error) {
          log('WebSocket Error: $error');
          _handleDisconnection();
        },
        onDone: () {
          log('WebSocket Connection Closed');
          _handleDisconnection();
        },
      );

      _isConnected = true;
      _onConnectionStatusChanged?.call(true);
      log('WebSocket connected successfully');
    } catch (e) {
      log('WebSocket Connection Error: $e');
      _handleDisconnection();
      // ลองเชื่อมต่อใหม่หลังจาก delay สักครู่
      Future.delayed(const Duration(seconds: 2), connect);
    }
  }

  @override
  Future<void> disconnect() async {
    log('Disconnecting from WebSocket...');

    // ปิดการเชื่อมต่อก่อนแล้วค่อยอัพเดทสถานะ
    try {
      _streamSubscription?.cancel();
      _channel?.sink.close(1000, 'Client disconnecting');
    } catch (e) {
      log('Error while disconnecting: $e');
    } finally {
      _streamSubscription = null;
      _channel = null;
      _isConnected = false;
      _onConnectionStatusChanged?.call(false);

      // สร้าง StreamController ใหม่เมื่อปิด
      if (_videoFrameController.isClosed) {
        _videoFrameController = StreamController<Uint8List>.broadcast();
      }
    }
  }

  @override
  Future<void> sendMessage(String message) async {
    if (_channel != null && _isConnected) {
      final messageMap = {'message': message};
      _channel!.sink.add(jsonEncode(messageMap));
      _onMessage?.call('Sent: $messageMap');
    }
  }

  @override
  void configure({
    required Function(String) onMessage,
    required Function(bool) onConnectionStatusChanged,
  }) {
    _onMessage = onMessage;
    _onConnectionStatusChanged = onConnectionStatusChanged;
  }

  void _handleDisconnection() {
    _isConnected = false;
    _onConnectionStatusChanged?.call(false);
    _cleanupConnections();
  }

  void _cleanupConnections() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    _channel = null;
  }

  void _handleMessage(Map<String, dynamic> json) {
    if (json['action'] == 'new') {
      _onMessage?.call('Fetched drugitems for VN: ${json['vn']}');
    }

    if (json['action'] == 'check') {
      _onMessage?.call('Changed status for VN: ${json['vn']} and Drug: ${json['drug']}');
    }

    if (json['action'] == 'finish') {
      _onMessage?.call('Finished for VN: ${json['vn']}');
    }
  }

  void dispose() {
    disconnect();
    _videoFrameController.close();
  }
}
