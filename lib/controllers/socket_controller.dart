import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoFrameController {
  final ValueNotifier<double> leftPosition = ValueNotifier(20.0);
  final ValueNotifier<double> bottomPosition = ValueNotifier(16.0);
  final AnimationController animationController;

  VideoFrameController({required this.animationController});

  void handlePositionBounds(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = 480.0;
    final containerHeight = containerWidth * 9 / 16;

    final appBarHeight = 170.0;
    final minTopPosition = appBarHeight + 10;

    double targetLeft = leftPosition.value;
    double targetBottom = bottomPosition.value;
    bool needsAnimation = false;

    // ตรวจสอบขอบเขตด้านซ้าย-ขวา
    if (leftPosition.value < 0) {
      targetLeft = 10;
      needsAnimation = true;
    } else if (leftPosition.value + containerWidth > screenWidth) {
      targetLeft = screenWidth - containerWidth - 10;
      needsAnimation = true;
    }

    final currentTopPosition = screenHeight - bottomPosition.value - containerHeight;

    if (currentTopPosition < minTopPosition) {
      targetBottom = screenHeight - minTopPosition - containerHeight;
      needsAnimation = true;
    } else if (bottomPosition.value < 0) {
      targetBottom = 10;
      needsAnimation = true;
    }

    if (needsAnimation) {
      Animation<double> leftAnim = Tween<double>(
        begin: leftPosition.value,
        end: targetLeft,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutBack,
        ),
      );

      Animation<double> bottomAnim = Tween<double>(
        begin: bottomPosition.value,
        end: targetBottom,
      ).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOutBack,
        ),
      );

      animationController.addListener(() {
        leftPosition.value = leftAnim.value;
        bottomPosition.value = bottomAnim.value;
      });

      animationController.reset();
      animationController.forward();
    }
  }

  void dispose() {
    leftPosition.dispose();
    bottomPosition.dispose();
  }
}

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

  void initSocket() {
    log('Connecting from WebSocket... Current status: $_isConnected');
    if (_isConnected) {
      log('Already connected, skipping...');
      return;
    }

    // ปิดการเชื่อมต่อเก่าก่อนเริ่มใหม่ (ถ้ามี)
    if (_channel != null) {
      disconnect();
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
              handleMessage(json);
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
      Future.delayed(Duration(seconds: 2), initSocket);
    }
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
