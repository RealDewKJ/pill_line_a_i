import 'package:equatable/equatable.dart';

class HomeData extends Equatable {
  final String title;
  final String description;
  final List<String> features;
  final Map<String, dynamic> settings;

  const HomeData({
    required this.title,
    required this.description,
    required this.features,
    required this.settings,
  });

  @override
  List<Object> get props => [title, description, features, settings];
}
