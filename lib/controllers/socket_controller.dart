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

    double targetLeft = leftPosition.value;
    double targetBottom = bottomPosition.value;
    bool needsAnimation = false;

    if (leftPosition.value < 0) {
      targetLeft = 10;
      needsAnimation = true;
    } else if (leftPosition.value + containerWidth > screenWidth) {
      targetLeft = screenWidth - containerWidth - 10;
      needsAnimation = true;
    }

    if (bottomPosition.value < 0) {
      targetBottom = 10;
      needsAnimation = true;
    } else if (bottomPosition.value + containerHeight > screenHeight) {
      targetBottom = screenHeight - containerHeight - 10;
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
  WebSocket? socket;
  bool isConnected = false;
  final _videoFrameController = StreamController<Uint8List>.broadcast();

  late void Function(String) onMessage;
  late void Function(bool) onConnectionStatusChanged;
  late BuildContext context;

  bool hasShownConnectionError = false;

  Stream<Uint8List> get videoFrameStream => _videoFrameController.stream;

  SocketController();

  void configure({
    required BuildContext context,
    required void Function(String) onMessage,
    required void Function(bool) onConnectionStatusChanged,
  }) {
    this.context = context;
    this.onMessage = onMessage;
    this.onConnectionStatusChanged = onConnectionStatusChanged;
  }

  Future<void> initSocket() async {
    log('initSocket');
    try {
      socket = await WebSocket.connect('ws://192.168.50.177:6789/ws/video-stream');
      isConnected = true;
      hasShownConnectionError = false;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      onConnectionStatusChanged(true);
      log('Connected to server');
      onMessage('Connected to server');

      // Listen for messages
      socket!.listen(
        (data) {
          try {
            if (data is List<int>) {
              // Handle binary video data
              _videoFrameController.add(Uint8List.fromList(data));
            } else {
              // Handle JSON messages
              final json = jsonDecode(data);
              handleMessage(json);
            }
          } catch (e) {
            onMessage('Error decoding message: $e');
          }
        },
        onError: (error) {
          if (!hasShownConnectionError) {
            hasShownConnectionError = true;
            serviceLocator<SocketErrorHandler>().handle(context, error);
          }
          onMessage('Connection error: $error');
          isConnected = false;
          onConnectionStatusChanged(false);
        },
        onDone: () {
          isConnected = false;
          onConnectionStatusChanged(false);
          onMessage('Disconnected from server');
        },
      );
    } catch (e) {
      if (!hasShownConnectionError) {
        hasShownConnectionError = true;
        serviceLocator<SocketErrorHandler>().handle(context, e);
      }
      onMessage('Connection error: $e');
      isConnected = false;
      onConnectionStatusChanged(false);
    }
  }

  void handleMessage(Map<String, dynamic> json) {
    if (json['action'] == 'new') {
      onMessage('Fetched drugitems for VN: ${json['vn']}');
    }

    if (json['action'] == 'check') {
      onMessage('Changed status for VN: ${json['vn']} and Drug: ${json['drug']}');
    }

    if (json['action'] == 'finish') {
      onMessage('Finished for VN: ${json['vn']}');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (socket != null && isConnected) {
      socket!.add(jsonEncode(message));
      onMessage('Sent: $message');
    }
  }

  void sendDrugDataToBackend({
    required String vn,
    required List<Map<String, dynamic>> drugItems,
  }) {
    if (!isConnected) return;

    final data = {
      'action': 'send_drug_data',
      'vn': vn,
      'total': drugItems.length,
      'drug': drugItems,
    };

    sendMessage(data);
  }

  void dispose() {
    socket?.close();
    socket = null;
    isConnected = false;
    _videoFrameController.close();
  }
}
