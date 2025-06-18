class ExNotDataConstants {
  // WebSocket Configuration
  static const String wsUrl = 'ws://192.168.50.177:6789/ws/action';
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration reconnectDelay = Duration(seconds: 2);
  static const Duration heartbeatInterval = Duration(seconds: 30);
  static const int maxReconnectAttempts = 5;

  // Rate Limiting
  static const Duration messageRateLimit = Duration(milliseconds: 500);
  static const int maxMessagesPerSecond = 10;
  static const int maxProcessedMessages = 100;

  // Navigation
  static const Duration navigationDebounceTime = Duration(seconds: 2);

  // Error Messages
  static const String connectionError = 'Failed to connect to WebSocket';
  static const String navigationError = 'Navigation callback not configured';
  static const String vnRequiredError = 'VN is required for new action';
  static const String unknownActionError = 'Unknown action received';

  // Action Types
  static const String actionNew = 'new';
  static const String actionUpdate = 'update';
  static const String actionDelete = 'delete';
  static const String actionCheck = 'check';

  // Message Types
  static const String typeNewAction = 'new_action';
  static const String typeUpdateAction = 'update_action';
  static const String typeDeleteAction = 'delete_action';
  static const String typeCheckAction = 'check_action';
  static const String typeError = 'error';
  static const String typeDrugitems = 'drugitems';
}
