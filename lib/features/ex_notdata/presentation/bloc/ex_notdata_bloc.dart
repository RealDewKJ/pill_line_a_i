import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'dart:async';
import 'dart:developer';
import '../../domain/repositories/ex_notdata_repository.dart';
import '../../domain/entities/ex_notdata.dart';
import '../../data/services/ex_notdata_websocket_service.dart';
import '../../data/services/ex_notdata_navigation_service.dart';
import '../../data/services/ex_notdata_message_handler.dart';
import '../../core/di/ex_notdata_di.dart';

// Navigation callback type
typedef NavigationCallback = void Function(String route, Map<String, dynamic>? arguments);

// Events
abstract class ExNotDataEvent extends Equatable {
  const ExNotDataEvent();

  @override
  List<Object> get props => [];
}

class LoadExNotData extends ExNotDataEvent {}

class InitializeWebSocket extends ExNotDataEvent {}

class HandleWebSocketMessage extends ExNotDataEvent {
  final Map<String, dynamic> message;

  const HandleWebSocketMessage(this.message);

  @override
  List<Object> get props => [message];
}

class HandleFetchedDrugitems extends ExNotDataEvent {
  final String message;

  const HandleFetchedDrugitems(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateExNotData extends ExNotDataEvent {
  final ExNotData data;

  const UpdateExNotData(this.data);

  @override
  List<Object> get props => [data];
}

class RefreshData extends ExNotDataEvent {}

class DisconnectWebSocket extends ExNotDataEvent {}

class ReconnectWebSocket extends ExNotDataEvent {}

class StopWebSocket extends ExNotDataEvent {}

class SetNavigationCallback extends ExNotDataEvent {
  final NavigationCallback callback;

  const SetNavigationCallback(this.callback);

  @override
  List<Object> get props => [callback];
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

class ExNotDataWebSocketConnected extends ExNotDataState {
  final ExNotData? data;

  const ExNotDataWebSocketConnected({this.data});

  @override
  List<Object> get props => [data ?? const ExNotData(message: '', type: '', details: {})];
}

class ExNotDataWebSocketDisconnected extends ExNotDataState {}

class ExNotDataWebSocketConnecting extends ExNotDataState {}

class ExNotDataWebSocketReconnecting extends ExNotDataState {
  final int attempt;
  final int maxAttempts;

  const ExNotDataWebSocketReconnecting({
    required this.attempt,
    required this.maxAttempts,
  });

  @override
  List<Object> get props => [attempt, maxAttempts];
}

// Bloc
class ExNotDataBloc extends Bloc<ExNotDataEvent, ExNotDataState> {
  final ExNotDataRepository repository;
  final ExNotDataWebSocketService _webSocketService;
  final ExNotDataNavigationService _navigationService;
  final ExNotDataMessageHandler _messageHandler;
  StreamSubscription? _webSocketSubscription;

  ExNotDataBloc({required this.repository})
      : _webSocketService = ExNotDataDI.webSocketService,
        _navigationService = ExNotDataDI.navigationService,
        _messageHandler = ExNotDataDI.messageHandler,
        super(ExNotDataInitial()) {
    on<LoadExNotData>(_onLoadExNotData);
    on<InitializeWebSocket>(_onInitializeWebSocket);
    on<HandleWebSocketMessage>(_onHandleWebSocketMessage);
    on<HandleFetchedDrugitems>(_onHandleFetchedDrugitems);
    on<UpdateExNotData>(_onUpdateExNotData);
    on<RefreshData>(_onRefreshData);
    on<DisconnectWebSocket>(_onDisconnectWebSocket);
    on<ReconnectWebSocket>(_onReconnectWebSocket);
    on<StopWebSocket>(_onStopWebSocket);
    on<SetNavigationCallback>(_onSetNavigationCallback);
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

  Future<void> _onInitializeWebSocket(
    InitializeWebSocket event,
    Emitter<ExNotDataState> emit,
  ) async {
    log('Initializing WebSocket for ExNotData...');

    if (_webSocketService.isConnected) {
      log('Already connected to ExNotData WebSocket');
      return;
    }

    try {
      emit(ExNotDataWebSocketConnecting());

      // Connect to WebSocket
      await _webSocketService.connect();

      // Listen to WebSocket messages
      _webSocketSubscription = _webSocketService.messageStream?.listen(
        (message) {
          add(HandleWebSocketMessage(message));
        },
        onError: (error) {
          log('WebSocket stream error: $error');
          add(HandleWebSocketMessage({
            'error': 'WebSocket stream error: $error',
            'timestamp': DateTime.now().toIso8601String(),
          }));
        },
      );

      // Load initial data
      await _loadInitialData();

      emit(const ExNotDataWebSocketConnected());
      log('ExNotData WebSocket initialized successfully');
    } catch (e) {
      emit(ExNotDataError('Failed to initialize WebSocket: $e'));
      log('Error initializing ExNotData WebSocket: $e');
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final result = await repository.getExNotData();
      result.fold(
        (error) => add(HandleWebSocketMessage({'error': error.toString()})),
        (data) => add(HandleWebSocketMessage({
          'message': data.message,
          'type': data.type,
          'details': data.details,
        })),
      );
    } catch (e) {
      add(HandleWebSocketMessage({'error': 'Failed to load initial data: $e'}));
    }
  }

  Future<void> _onHandleWebSocketMessage(
    HandleWebSocketMessage event,
    Emitter<ExNotDataState> emit,
  ) async {
    try {
      final exNotData = _messageHandler.handleMessage(event.message);

      if (exNotData != null) {
        emit(ExNotDataWebSocketConnected(data: exNotData));
      }
    } catch (e) {
      log('Error handling WebSocket message: $e');
      emit(ExNotDataError('Error processing message: $e'));
    }
  }

  Future<void> _onHandleFetchedDrugitems(
    HandleFetchedDrugitems event,
    Emitter<ExNotDataState> emit,
  ) async {
    try {
      final exNotData = ExNotData(
        message: event.message,
        type: 'drugitems',
        details: {
          'timestamp': DateTime.now().toIso8601String(),
          'action': 'fetched',
        },
      );
      add(UpdateExNotData(exNotData));
    } catch (e) {
      emit(ExNotDataError('Failed to handle drug items fetched: $e'));
    }
  }

  Future<void> _onUpdateExNotData(
    UpdateExNotData event,
    Emitter<ExNotDataState> emit,
  ) async {
    try {
      emit(ExNotDataLoading());
      final result = await repository.updateExNotData(event.data);
      result.fold(
        (error) => emit(ExNotDataError(error.toString())),
        (_) {
          emit(ExNotDataWebSocketConnected(data: event.data));
          log('ExNotData updated successfully');
        },
      );
    } catch (e) {
      emit(ExNotDataError('Failed to update ExNotData: $e'));
    }
  }

  Future<void> _onRefreshData(
    RefreshData event,
    Emitter<ExNotDataState> emit,
  ) async {
    try {
      emit(ExNotDataLoading());
      final result = await repository.getExNotData();
      result.fold(
        (error) => emit(ExNotDataError(error.toString())),
        (data) => emit(ExNotDataWebSocketConnected(data: data)),
      );
    } catch (e) {
      emit(ExNotDataError('Failed to refresh data: $e'));
    }
  }

  Future<void> _onDisconnectWebSocket(
    DisconnectWebSocket event,
    Emitter<ExNotDataState> emit,
  ) async {
    log('Disconnecting from ExNotData WebSocket...');

    try {
      _webSocketSubscription?.cancel();
      await _webSocketService.disconnect();

      emit(ExNotDataWebSocketDisconnected());
      log('Disconnected from ExNotData WebSocket');
    } catch (e) {
      log('Error disconnecting from WebSocket: $e');
    }
  }

  Future<void> _onReconnectWebSocket(
    ReconnectWebSocket event,
    Emitter<ExNotDataState> emit,
  ) async {
    log('Reconnecting to ExNotData WebSocket...');

    add(DisconnectWebSocket());
    await Future.delayed(const Duration(seconds: 1));
    add(InitializeWebSocket());
  }

  Future<void> _onStopWebSocket(
    StopWebSocket event,
    Emitter<ExNotDataState> emit,
  ) async {
    log('Stopping ExNotData WebSocket...');

    try {
      _webSocketSubscription?.cancel();
      await _webSocketService.stop();

      emit(ExNotDataWebSocketDisconnected());
      log('Stopped ExNotData WebSocket');
    } catch (e) {
      log('Error stopping WebSocket: $e');
    }
  }

  void _onSetNavigationCallback(
    SetNavigationCallback event,
    Emitter<ExNotDataState> emit,
  ) {
    _navigationService.setNavigationCallback(event.callback);
    log('Navigation callback set in BLoC');
  }

  // Public methods
  bool get isWebSocketActive => _webSocketService.isConnected;
  String get connectionStatus => _webSocketService.isConnected ? 'Connected' : 'Disconnected';
  bool get hasNavigationCallback => _navigationService.hasNavigationCallback;

  @override
  Future<void> close() {
    _webSocketSubscription?.cancel();
    return super.close();
  }
}
