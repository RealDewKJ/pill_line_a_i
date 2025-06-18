import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';

class ExNotDataWebSocketService {
  WebSocket? _webSocket;
  bool _isConnected = false;
  bool _isReconnecting = false;
  int _reconnectAttempts = 0;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  StreamSubscription? _webSocketSubscription;
  StreamController<Map<String, dynamic>>? _messageController;

  // Configuration
  static const String _wsUrl = 'ws://192.168.50.177:6789/ws/action';
  static const Duration _connectionTimeout = Duration(seconds: 10);
  static const Duration _reconnectDelay = Duration(seconds: 2);
  static const Duration _heartbeatInterval = Duration(seconds: 30);
  static const int _maxReconnectAttempts = 5;

  // Rate limiting and debounce
  static const Duration _messageRateLimit = Duration(milliseconds: 500);
  static const int _maxMessagesPerSecond = 10;

  Timer? _rateLimitTimer;
  int _messageCount = 0;
  DateTime _lastMessageReset = DateTime.now();
  final Set<String> _processedMessages = <String>{};
  static const int _maxProcessedMessages = 100;

  // Getters
  bool get isConnected => _isConnected;
  bool get isReconnecting => _isReconnecting;
  int get reconnectAttempts => _reconnectAttempts;
  Stream<Map<String, dynamic>>? get messageStream => _messageController?.stream;

  ExNotDataWebSocketService() {
    _messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  Future<void> connect() async {
    if (_isConnected) {
      log('Already connected to WebSocket');
      return;
    }

    try {
      log('Connecting to WebSocket at $_wsUrl...');

      _webSocket = await WebSocket.connect(
        _wsUrl,
        headers: {
          'User-Agent': 'PillLineAI/1.0',
          'Connection': 'Upgrade',
        },
      ).timeout(_connectionTimeout);

      _isConnected = true;
      _reconnectAttempts = 0;
      _isReconnecting = false;

      _webSocketSubscription = _webSocket!.listen(
        _handleWebSocketData,
        onError: _handleWebSocketError,
        onDone: _handleWebSocketDone,
        cancelOnError: false,
      );

      _startHeartbeat();
      log('Successfully connected to WebSocket at $_wsUrl');
    } catch (e) {
      _isConnected = false;
      throw Exception('Failed to connect to WebSocket: $e');
    }
  }

  void _handleWebSocketData(dynamic data) {
    try {
      if (_isRateLimited()) {
        log('Message dropped due to rate limiting');
        return;
      }

      dynamic message;
      if (data is String) {
        try {
          message = jsonDecode(data);
        } catch (e) {
          message = data;
        }
      } else {
        message = data;
      }

      if (message is Map<String, dynamic> && _isDuplicateMessage(message)) {
        log('Duplicate message dropped');
        return;
      }

      if (message is Map<String, dynamic>) {
        _messageController?.add(message);
      }
    } catch (e) {
      log('Error handling WebSocket data: $e');
    }
  }

  void _handleWebSocketError(error) {
    log('WebSocket error: $error');
    _isConnected = false;

    _messageController?.add({
      'error': 'WebSocket error: $error',
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (!_isReconnecting) {
      _startReconnection();
    }
  }

  void _handleWebSocketDone() {
    log('WebSocket connection closed');
    _isConnected = false;

    _messageController?.add({
      'message': 'WebSocket connection closed',
      'type': 'disconnect',
      'timestamp': DateTime.now().toIso8601String(),
    });

    if (!_isReconnecting) {
      _startReconnection();
    }
  }

  void _startReconnection() {
    if (_isReconnecting || _reconnectAttempts >= _maxReconnectAttempts) {
      log('Max reconnection attempts reached or already reconnecting');
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;

    log('Starting reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts');

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () async {
      try {
        await connect();
        _isReconnecting = false;
        log('Reconnection successful');
      } catch (e) {
        log('Reconnection attempt $_reconnectAttempts failed: $e');
        if (_reconnectAttempts < _maxReconnectAttempts) {
          _startReconnection();
        } else {
          _isReconnecting = false;
          log('Max reconnection attempts reached');
        }
      }
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (timer) {
      if (_isConnected && _webSocket != null) {
        try {
          _webSocket!.add(jsonEncode({
            'type': 'heartbeat',
            'timestamp': DateTime.now().toIso8601String(),
          }));
          log('Heartbeat sent');
        } catch (e) {
          log('Error sending heartbeat: $e');
          _handleWebSocketError(e);
        }
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  bool _isRateLimited() {
    final now = DateTime.now();
    if (now.difference(_lastMessageReset).inSeconds >= 1) {
      _messageCount = 0;
      _lastMessageReset = now;
    }

    if (_messageCount >= _maxMessagesPerSecond) {
      log('Rate limit exceeded: $_messageCount messages per second');
      return true;
    }

    _messageCount++;
    return false;
  }

  bool _isDuplicateMessage(Map<String, dynamic> message) {
    final messageKey = jsonEncode(message);

    if (_processedMessages.contains(messageKey)) {
      log('Duplicate message detected: $messageKey');
      return true;
    }

    _processedMessages.add(messageKey);

    if (_processedMessages.length > _maxProcessedMessages) {
      final oldestMessages = _processedMessages.take(_processedMessages.length - _maxProcessedMessages);
      _processedMessages.removeAll(oldestMessages);
    }

    return false;
  }

  Future<void> disconnect() async {
    log('Disconnecting from WebSocket...');

    try {
      _stopHeartbeat();
      _reconnectTimer?.cancel();
      _rateLimitTimer?.cancel();
      _webSocketSubscription?.cancel();

      if (_webSocket != null) {
        await _webSocket!.close();
        _webSocket = null;
      }

      _isConnected = false;
      _isReconnecting = false;
      _reconnectAttempts = 0;
      _processedMessages.clear();
      _messageCount = 0;

      log('Disconnected from WebSocket');
    } catch (e) {
      log('Error disconnecting from WebSocket: $e');
    }
  }

  Future<void> stop() async {
    log('Stopping WebSocket...');

    try {
      _stopHeartbeat();
      _reconnectTimer?.cancel();
      _rateLimitTimer?.cancel();
      _webSocketSubscription?.cancel();

      if (_webSocket != null) {
        await _webSocket!.close();
        _webSocket = null;
      }

      _isConnected = false;
      _isReconnecting = false;
      _reconnectAttempts = 0;
      _processedMessages.clear();
      _messageCount = 0;

      log('Stopped WebSocket');
    } catch (e) {
      log('Error stopping WebSocket: $e');
    }
  }

  void dispose() {
    _stopHeartbeat();
    _reconnectTimer?.cancel();
    _rateLimitTimer?.cancel();
    _webSocketSubscription?.cancel();
    _webSocket?.close();
    _processedMessages.clear();
    _messageController?.close();
  }
}
