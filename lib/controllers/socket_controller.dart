import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketController {
  WebSocketChannel? _channel;
  StreamSubscription? _streamSubscription;
  var _videoFrameController = StreamController<Uint8List>.broadcast();
  bool _isConnected = false;
  Function(String)? _onMessage;
  Function(bool)? _onConnectionStatusChanged;

  Stream<Uint8List> get videoFrameStream => _videoFrameController.stream;

  void configure({
    required BuildContext context,
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

  void handleMessage(Map<String, dynamic> json) {
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

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(jsonEncode(message));
      _onMessage?.call('Sent: $message');
    }
  }

  void sendDrugDataToBackend({
    required String vn,
    required List<Map<String, dynamic>> drugItems,
  }) {
    if (!_isConnected) {
      log('Cannot send drug data: WebSocket not connected');
      return;
    }

    final data = {
      'action': 'send_drug_data',
      'vn': vn,
      'total': drugItems.length,
      'drug': drugItems,
    };

    sendMessage(data);
  }

  void disconnect() {
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

  void dispose() {
    disconnect();
  }
}
