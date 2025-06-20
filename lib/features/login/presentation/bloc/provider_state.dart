import 'package:equatable/equatable.dart';

class ProviderState extends Equatable {
  final Map<String, dynamic>? profile;
  final String? token;

  const ProviderState({this.profile, this.token});

  @override
  List<Object?> get props => [profile, token];
}

class ProviderInitial extends ProviderState {}

class ProviderLoaded extends ProviderState {
  const ProviderLoaded({required Map<String, dynamic> profile, required String token}) : super(profile: profile, token: token);
}
