import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NotFoundEvent extends Equatable {
  const NotFoundEvent();

  @override
  List<Object> get props => [];
}

class NavigateBack extends NotFoundEvent {}

// States
abstract class NotFoundState extends Equatable {
  const NotFoundState();

  @override
  List<Object> get props => [];
}

class NotFoundInitial extends NotFoundState {}

class NotFoundNavigating extends NotFoundState {}

// Bloc
class NotFoundBloc extends Bloc<NotFoundEvent, NotFoundState> {
  NotFoundBloc() : super(NotFoundInitial()) {
    on<NavigateBack>(_onNavigateBack);
  }

  void _onNavigateBack(
    NavigateBack event,
    Emitter<NotFoundState> emit,
  ) {
    emit(NotFoundNavigating());
  }
}
