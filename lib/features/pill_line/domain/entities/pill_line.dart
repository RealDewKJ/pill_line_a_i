import 'package:equatable/equatable.dart';

class PillLine extends Equatable {
  final String id;
  final String name;
  final String status;
  final DateTime lastUpdated;

  const PillLine({
    required this.id,
    required this.name,
    required this.status,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [id, name, status, lastUpdated];
}
