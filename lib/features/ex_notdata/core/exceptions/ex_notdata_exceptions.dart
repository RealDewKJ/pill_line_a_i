class ExNotDataException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const ExNotDataException(this.message, {this.code, this.details});

  @override
  String toString() => 'ExNotDataException: $message${code != null ? ' (Code: $code)' : ''}';
}

class ExNotDataConnectionException extends ExNotDataException {
  const ExNotDataConnectionException(super.message, {super.code, super.details});
}

class ExNotDataNavigationException extends ExNotDataException {
  const ExNotDataNavigationException(super.message, {super.code, super.details});
}

class ExNotDataMessageException extends ExNotDataException {
  const ExNotDataMessageException(super.message, {super.code, super.details});
}
