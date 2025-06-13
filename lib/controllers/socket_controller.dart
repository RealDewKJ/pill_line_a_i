import 'dart:convert';
import 'dart:developer';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';
import 'package:pill_line_a_i/utils/socket_error_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';

class SocketController {
  late io.Socket socket;

  late void Function(String) onMessage;
  late void Function(bool) onConnectionStatusChanged;
  late BuildContext context;

  bool hasShownConnectionError = false;

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

  void initSocket() {
    socket = io.io('http://10.91.114.73:5000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.connect();

    socket.on('connect', (_) {
      hasShownConnectionError = false;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      onConnectionStatusChanged(true);
      log('Connected to server');
      onMessage('Connected to server');
      // sendInitMessage();
    });

    socket.on('disconnect', (_) {
      onConnectionStatusChanged(false);
      onMessage('Disconnected from server');
    });

    socket.on('new_message', (data) async {
      try {
        late Map<String, dynamic> json;

        if (data is Map<String, dynamic>) {
          json = data;
        } else if (data is String) {
          json = jsonDecode(data);
        } else {
          throw const FormatException('Unknown data format');
        }

        if (json['action'] == 'new') {
          onMessage('Fetched drugitems for VN: ${json['vn']}');
        }

        if (json['action'] == 'check') {
          onMessage('Changed status for VN: ${json['vn']} and Drug: ${json['drug']}');
        }

        if (json['action'] == 'finish') {
          onMessage('Finished for VN: ${json['vn']}');
        }

        // onMessage('Received valid JSON: $json');
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
