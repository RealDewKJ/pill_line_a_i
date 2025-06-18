class ExNotDataException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const ExNotDataException(this.message, {this.code, this.details});

  @override
  String toString() => 'ExNotDataException: $message${code != null ? ' (Code: $code)' : ''}';
}

class ExNotDataConnectionException extends ExNotDataException {
  const ExNotDataConnectionException(String message, {String? code, dynamic details}) : super(message, code: code, details: details);
}

class ExNotDataNavigationException extends ExNotDataException {
  const ExNotDataNavigationException(String message, {String? code, dynamic details}) : super(message, code: code, details: details);
}

class ExNotDataMessageException extends ExNotDataException {
  const ExNotDataMessageException(String message, {String? code, dynamic details}) : super(message, code: code, details: details);
}
