import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/ex_notdata_repository.dart';
import '../../domain/entities/ex_notdata.dart';

// Events
abstract class ExNotDataEvent extends Equatable {
  const ExNotDataEvent();

  @override
  List<Object> get props => [];
}

class LoadExNotData extends ExNotDataEvent {}

class HandleFetchedDrugitems extends ExNotDataEvent {
  final String message;

  const HandleFetchedDrugitems(this.message);

  @override
  List<Object> get props => [message];
}

// States
abstract class ExNotDataState extends Equatable {
  const ExNotDataState();

  @override
  List<Object> get props => [];
}

class ExNotDataInitial extends ExNotDataState {}

class ExNotDataLoading extends ExNotDataState {}

class ExNotDataLoaded extends ExNotDataState {
  final ExNotData data;

  const ExNotDataLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ExNotDataError extends ExNotDataState {
  final String message;

  const ExNotDataError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ExNotDataBloc extends Bloc<ExNotDataEvent, ExNotDataState> {
  final ExNotDataRepository repository;

  ExNotDataBloc({required this.repository}) : super(ExNotDataInitial()) {
    on<LoadExNotData>(_onLoadExNotData);
    on<HandleFetchedDrugitems>(_onHandleFetchedDrugitems);
  }

  Future<void> _onLoadExNotData(
    LoadExNotData event,
    Emitter<ExNotDataState> emit,
  ) async {
    emit(ExNotDataLoading());
    try {
      final result = await repository.getExNotData();
      result.fold(
        (error) => emit(ExNotDataError(error.toString())),
        (data) => emit(ExNotDataLoaded(data)),
      );
    } catch (e) {
      emit(ExNotDataError(e.toString()));
    }
  }

  Future<void> _onHandleFetchedDrugitems(
    HandleFetchedDrugitems event,
    Emitter<ExNotDataState> emit,
  ) async {
    try {
      final result = await repository.updateExNotData(
        ExNotData(
          message: event.message,
          type: 'drugitems',
          details: {'timestamp': DateTime.now().toIso8601String()},
        ),
      );
      result.fold(
        (error) => emit(ExNotDataError(error.toString())),
        (_) => add(LoadExNotData()),
      );
    } catch (e) {
      emit(ExNotDataError(e.toString()));
    }
  }
}
