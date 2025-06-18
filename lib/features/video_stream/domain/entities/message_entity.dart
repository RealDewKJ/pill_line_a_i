class MessageEntity {
  final String content;
  final String? vn;
  final DateTime timestamp;
  final MessageType type;

  const MessageEntity({
    required this.content,
    this.vn,
    required this.timestamp,
    required this.type,
  });

  factory MessageEntity.fromSocketMessage(String message) {
    final timestamp = DateTime.now();
    final type = _determineMessageType(message);
    final vn = _extractVNFromMessage(message);

    return MessageEntity(
      content: message,
      vn: vn,
      timestamp: timestamp,
      type: type,
    );
  }

  static MessageType _determineMessageType(String message) {
    if (message.contains('Fetched drugitems for VN:')) {
      return MessageType.drugItemsFetched;
    } else if (message.contains('error') || message.contains('Error')) {
      return MessageType.error;
    } else if (message.contains('connected') || message.contains('Connected')) {
      return MessageType.connection;
    }
    return MessageType.general;
  }

  static String? _extractVNFromMessage(String message) {
    const prefix = 'Fetched drugitems for VN:';
    if (message.contains(prefix)) {
      return message.substring(message.indexOf(prefix) + prefix.length).trim();
    }
    return null;
  }
}

enum MessageType {
  drugItemsFetched,
  error,
  connection,
  general,
}
