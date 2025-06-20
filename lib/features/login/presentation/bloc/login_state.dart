import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> userData;
  LoginSuccess(this.userData);
  @override
  List<Object?> get props => [userData];
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
  @override
  List<Object?> get props => [error];
}
