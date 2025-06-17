import 'package:equatable/equatable.dart';

class ExNotData extends Equatable {
  final String message;
  final String type;
  final Map<String, dynamic> details;

  const ExNotData({
    required this.message,
    required this.type,
    required this.details,
  });

  @override
  List<Object> get props => [message, type, details];
}
