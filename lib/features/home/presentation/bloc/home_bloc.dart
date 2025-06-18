import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../domain/usecases/update_home_settings_usecase.dart';
import '../../domain/entities/home_data.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class UpdateHomeSettings extends HomeEvent {
  final Map<String, dynamic> settings;

  const UpdateHomeSettings(this.settings);

  @override
  List<Object> get props => [settings];
}

class RefreshHomeData extends HomeEvent {}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeData homeData;
  final bool isRefreshing;

  const HomeLoaded({
    required this.homeData,
    this.isRefreshing = false,
  });

  @override
  List<Object> get props => [homeData, isRefreshing];

  HomeLoaded copyWith({
    HomeData? homeData,
    bool? isRefreshing,
  }) {
    return HomeLoaded(
      homeData: homeData ?? this.homeData,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class SettingsUpdating extends HomeState {
  final HomeData homeData;

  const SettingsUpdating(this.homeData);

  @override
  List<Object> get props => [homeData];
}

class SettingsUpdated extends HomeState {
  final HomeData homeData;

  const SettingsUpdated(this.homeData);

  @override
  List<Object> get props => [homeData];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;
  final UpdateHomeSettingsUseCase updateHomeSettingsUseCase;

  HomeBloc({
    required this.getHomeDataUseCase,
    required this.updateHomeSettingsUseCase,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<UpdateHomeSettings>(_onUpdateHomeSettings);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _loadHomeData(emit);
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    }
    await _loadHomeData(emit);
  }

  Future<void> _loadHomeData(Emitter<HomeState> emit) async {
    try {
      final result = await getHomeDataUseCase();
      result.fold(
        (error) => emit(HomeError(error.toString())),
        (homeData) => emit(HomeLoaded(homeData: homeData)),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onUpdateHomeSettings(
    UpdateHomeSettings event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(SettingsUpdating(currentState.homeData));

      try {
        final result = await updateHomeSettingsUseCase(event.settings);
        result.fold(
          (error) => emit(HomeError(error.toString())),
          (_) => emit(SettingsUpdated(currentState.homeData)),
        );
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }
}
