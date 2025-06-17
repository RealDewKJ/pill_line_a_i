import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/pill_line_repository.dart';
import '../../domain/entities/pill_line.dart';

// Events
abstract class PillLineEvent extends Equatable {
  const PillLineEvent();

  @override
  List<Object> get props => [];
}

class LoadPillLine extends PillLineEvent {}

// States
abstract class PillLineState extends Equatable {
  const PillLineState();

  @override
  List<Object> get props => [];
}

class PillLineInitial extends PillLineState {}

class PillLineLoading extends PillLineState {}

class PillLineLoaded extends PillLineState {
  final List<PillLine> pillLines;

  const PillLineLoaded(this.pillLines);

  @override
  List<Object> get props => [pillLines];
}

class PillLineError extends PillLineState {
  final String message;

  const PillLineError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class PillLineBloc extends Bloc<PillLineEvent, PillLineState> {
  final PillLineRepository repository;

  PillLineBloc({required this.repository}) : super(PillLineInitial()) {
    on<LoadPillLine>(_onLoadPillLine);
  }

  Future<void> _onLoadPillLine(
    LoadPillLine event,
    Emitter<PillLineState> emit,
  ) async {
    emit(PillLineLoading());
    try {
      final result = await repository.getPillLines();
      result.fold(
        (error) => emit(PillLineError(error.toString())),
        (pillLines) => emit(PillLineLoaded(pillLines)),
      );
    } catch (e) {
      emit(PillLineError(e.toString()));
    }
  }
}
