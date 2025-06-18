import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/repositories/ex_notdata_repository.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/core/di/ex_notdata_di.dart';

import 'ex_notdata_bloc_test.mocks.dart';

@GenerateMocks([ExNotDataRepository])
void main() {
  group('ExNotDataBloc', () {
    late MockExNotDataRepository mockRepository;
    late ExNotDataBloc bloc;

    setUp(() {
      ExNotDataDI.reset();
      ExNotDataDI.init();

      mockRepository = MockExNotDataRepository();
      bloc = ExNotDataBloc(repository: mockRepository);
    });

    tearDown(() {
      bloc.close();
    });

    group('Initialization', () {
      test('initial state should be ExNotDataInitial', () {
        expect(bloc.state, isA<ExNotDataInitial>());
      });

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should load ExNotData successfully',
        build: () {
          final testData = ExNotData(
            message: 'Test data',
            type: 'test',
            details: {},
          );
          when(mockRepository.getExNotData()).thenAnswer((_) async => Right(testData));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadExNotData()),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataLoaded>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle load error',
        build: () {
          when(mockRepository.getExNotData()).thenAnswer((_) async => Left(Exception('Load failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadExNotData()),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataError>(),
        ],
      );
    });

    group('WebSocket Operations', () {
      blocTest<ExNotDataBloc, ExNotDataState>(
        'should initialize WebSocket successfully',
        build: () {
          final testData = ExNotData(
            message: 'Test data',
            type: 'test',
            details: {},
          );
          when(mockRepository.getExNotData()).thenAnswer((_) async => Right(testData));
          return bloc;
        },
        act: (bloc) => bloc.add(InitializeWebSocket()),
        expect: () => [
          isA<ExNotDataWebSocketConnecting>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle WebSocket initialization error',
        build: () {
          when(mockRepository.getExNotData()).thenAnswer((_) async => Left(Exception('Connection failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(InitializeWebSocket()),
        expect: () => [
          isA<ExNotDataWebSocketConnecting>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle WebSocket message with new action',
        build: () => bloc,
        act: (bloc) => bloc.add(HandleWebSocketMessage({
          'action': 'new',
          'vn': '680612084046',
        })),
        expect: () => [
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle WebSocket message with update action',
        build: () => bloc,
        act: (bloc) => bloc.add(HandleWebSocketMessage({
          'action': 'update',
          'message': 'Updated data',
          'id': '123',
        })),
        expect: () => [
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle WebSocket message with delete action',
        build: () => bloc,
        act: (bloc) => bloc.add(HandleWebSocketMessage({
          'action': 'delete',
          'message': 'Deleted data',
          'id': '123',
        })),
        expect: () => [
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle WebSocket message with unknown action',
        build: () => bloc,
        act: (bloc) => bloc.add(HandleWebSocketMessage({
          'action': 'unknown',
          'data': 'test',
        })),
        expect: () => [
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle WebSocket message with error',
        build: () => bloc,
        act: (bloc) => bloc.add(HandleWebSocketMessage({
          'error': 'WebSocket error occurred',
          'timestamp': '2024-01-01T00:00:00Z',
        })),
        expect: () => [
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should disconnect WebSocket successfully',
        build: () => bloc,
        act: (bloc) => bloc.add(DisconnectWebSocket()),
        expect: () => [
          isA<ExNotDataWebSocketDisconnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should reconnect WebSocket successfully',
        build: () {
          final testData = ExNotData(
            message: 'Test data',
            type: 'test',
            details: {},
          );
          when(mockRepository.getExNotData()).thenAnswer((_) async => Right(testData));
          return bloc;
        },
        act: (bloc) => bloc.add(ReconnectWebSocket()),
        expect: () => [
          isA<ExNotDataWebSocketDisconnected>(),
        ],
      );
    });

    group('Data Operations', () {
      blocTest<ExNotDataBloc, ExNotDataState>(
        'should update ExNotData successfully',
        build: () {
          final testData = ExNotData(
            message: 'Test message',
            type: 'test',
            details: {'key': 'value'},
          );
          when(mockRepository.updateExNotData(testData)).thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateExNotData(ExNotData(
          message: 'Test message',
          type: 'test',
          details: {'key': 'value'},
        ))),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle update error',
        build: () {
          final testData = ExNotData(
            message: 'Test message',
            type: 'test',
            details: {'key': 'value'},
          );
          when(mockRepository.updateExNotData(testData)).thenAnswer((_) async => Left(Exception('Update failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(UpdateExNotData(ExNotData(
          message: 'Test message',
          type: 'test',
          details: {'key': 'value'},
        ))),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataError>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should refresh data successfully',
        build: () {
          final testData = ExNotData(
            message: 'Refreshed data',
            type: 'refresh',
            details: {'timestamp': '2024-01-01'},
          );
          when(mockRepository.getExNotData()).thenAnswer((_) async => Right(testData));
          return bloc;
        },
        act: (bloc) => bloc.add(RefreshData()),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataWebSocketConnected>(),
        ],
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'should handle drug items fetched',
        build: () {
          when(mockRepository.updateExNotData(any)).thenAnswer((_) async => const Right(unit));
          return bloc;
        },
        act: (bloc) => bloc.add(HandleFetchedDrugitems('Drug items fetched successfully')),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataWebSocketConnected>(),
        ],
      );
    });

    group('Navigation', () {
      test('should set navigation callback', () {
        // Act
        bloc.add(SetNavigationCallback((route, arguments) {
          // Test callback
        }));

        // Assert - should not emit any state
        expect(bloc.state, isA<ExNotDataInitial>());
      });
    });

    group('State Properties', () {
      test('ExNotDataWebSocketReconnecting should have correct properties', () {
        // Arrange
        const state = ExNotDataWebSocketReconnecting(attempt: 3, maxAttempts: 5);

        // Assert
        expect(state.attempt, equals(3));
        expect(state.maxAttempts, equals(5));
        expect(state.props, equals([3, 5]));
      });

      test('ExNotDataWebSocketConnected should handle null data', () {
        // Arrange
        const state = ExNotDataWebSocketConnected(data: null);

        // Assert
        expect(state.data, isNull);
        expect(state.props, equals([const ExNotData(message: '', type: '', details: {})]));
      });

      test('ExNotDataWebSocketConnected should handle data', () {
        // Arrange
        final testData = ExNotData(
          message: 'Test',
          type: 'test',
          details: {'key': 'value'},
        );
        final state = ExNotDataWebSocketConnected(data: testData);

        // Assert
        expect(state.data, equals(testData));
        expect(state.props, equals([testData]));
      });
    });
  });
}
