import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LoginWithMophProvider extends LoginEvent {
  final String sjwt;
  LoginWithMophProvider({required this.sjwt});

  @override
  List<Object?> get props => [sjwt];
}

class LoginWithMophOAuthPressed extends LoginEvent {
  final BuildContext context;
  LoginWithMophOAuthPressed({required this.context});
  @override
  List<Object?> get props => [context];
}
