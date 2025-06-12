import 'dart:convert';
import 'package:pill_line_a_i/controllers/pill_line_controller.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class SocketController {
  late IO.Socket socket;
  final void Function(String) onMessage;
  final void Function(bool) onConnectionStatusChanged;
  final BuildContext context;
  bool hasShownConnectionError = false;

  SocketController({
    required this.context,
    required this.onMessage,
    required this.onConnectionStatusChanged,
  });

  void initSocket() {
    socket = IO.io('http://10.91.114.73:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();

    socket.on('connect', (_) {
      hasShownConnectionError = false;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      onConnectionStatusChanged(true);
      onMessage('Connected to server');
      sendInitMessage();
    });

    socket.on('disconnect', (_) {
      onConnectionStatusChanged(false);
      onMessage('Disconnected from server');
    });

    socket.on('new_message', (data) async {
      try {
        late Map<String, dynamic> json;

        // เช็คชนิดข้อมูลที่รับมา
        if (data is Map<String, dynamic>) {
          json = data;
        } else if (data is String) {
          json = jsonDecode(data);
        } else {
          throw FormatException('Unknown data format');
        }

        // ตรวจสอบ action == 'new'
        if (json['action'] == 'new') {
          onMessage('Fetched drugitems for VN: ${json['vn']}');
        }

        // ส่งข้อมูลดิบ (หรือ json) กลับไปใน onMessage ด้วย
        onMessage('Received valid JSON: $json');
      } catch (e) {
        onMessage('Error decoding JSON: $e');
      }
    });

    socket.on('message_sent', (data) {
      onMessage('Sent confirmation: $data');
    });

    socket.on('connect_error', (data) {
      if (!hasShownConnectionError) {
        hasShownConnectionError = true;
        serviceLocator<SocketErrorHandler>().handle(context, data);
      }
      onMessage('Connection error: $data');
    });

    socket.on('error', (data) {
      onMessage('Socket error: $data');
    });
  }

  void sendInitMessage() {
    if (socket.connected) {
      final msg = {
        'text': 'Init',
        'timestamp': DateTime.now().toIso8601String(),
        'from': 'flutter_app',
      };
      socket.emit('send_message', msg);
      onMessage('Sent Init: $msg');
    }
  }

  void sendTestMessage() {
    if (socket.connected) {
      final msg = {
        'text': 'Hello from Flutter',
        'user': 'flutter_user',
        'timestamp': DateTime.now().toIso8601String(),
        'type': 'test',
      };
      socket.emit('send_message', msg);
      onMessage('Sent: $msg');
    }
  }

  void sendDrugDataToBackend({
    required String vn,
    required List<Map<String, dynamic>> drugItems,
  }) {
    if (!socket.connected) return;

    final data = {
      'vn': vn,
      'total': drugItems.length,
      'drug': drugItems,
    };

    socket.emit('send_drug_data', data);
    onMessage('Sent drug data: $data');
  }

  void dispose() {
    socket.clearListeners();
    socket.disconnect();
  }
}
