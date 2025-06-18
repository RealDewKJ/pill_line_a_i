import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/repositories/ex_notdata_repository.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';

import 'ex_notdata_bloc_test.mocks.dart';

@GenerateMocks([ExNotDataRepository])
void main() {
  group('ExNotDataBloc', () {
    late MockExNotDataRepository mockRepository;
    late ExNotDataBloc bloc;

    setUp(() {
      mockRepository = MockExNotDataRepository();
      bloc = ExNotDataBloc(repository: mockRepository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state should be ExNotDataInitial', () {
      expect(bloc.state, isA<ExNotDataInitial>());
    });

    group('LoadExNotData', () {
      final testExNotData = ExNotData(
        message: 'Test message',
        type: 'test',
        details: {'key': 'value'},
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'emits [ExNotDataLoading, ExNotDataLoaded] when LoadExNotData is successful',
        build: () {
          when(mockRepository.getExNotData()).thenAnswer((_) async => Right(testExNotData));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadExNotData()),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataLoaded>(),
        ],
        verify: (_) {
          verify(mockRepository.getExNotData()).called(1);
        },
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'emits [ExNotDataLoading, ExNotDataError] when LoadExNotData fails',
        build: () {
          when(mockRepository.getExNotData()).thenAnswer((_) async => Left(Exception('Error')));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadExNotData()),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataError>(),
        ],
        verify: (_) {
          verify(mockRepository.getExNotData()).called(1);
        },
      );
    });

    group('HandleFetchedDrugitems', () {
      final testMessage = 'Drug items fetched successfully';

      blocTest<ExNotDataBloc, ExNotDataState>(
        'emits [ExNotDataLoading, ExNotDataLoaded] when HandleFetchedDrugitems is successful',
        build: () {
          when(mockRepository.updateExNotData(any)).thenAnswer((_) async => const Right(null));
          when(mockRepository.getExNotData()).thenAnswer((_) async => Right(ExNotData(
                message: 'Updated',
                type: 'drugitems',
                details: {},
              )));
          return bloc;
        },
        act: (bloc) => bloc.add(HandleFetchedDrugitems(testMessage)),
        expect: () => [
          isA<ExNotDataLoading>(),
          isA<ExNotDataLoaded>(),
        ],
        verify: (_) {
          verify(mockRepository.updateExNotData(any)).called(1);
          verify(mockRepository.getExNotData()).called(1);
        },
      );

      blocTest<ExNotDataBloc, ExNotDataState>(
        'emits [ExNotDataError] when HandleFetchedDrugitems fails',
        build: () {
          when(mockRepository.updateExNotData(any)).thenAnswer((_) async => Left(Exception('Update failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(HandleFetchedDrugitems(testMessage)),
        expect: () => [
          isA<ExNotDataError>(),
        ],
        verify: (_) {
          verify(mockRepository.updateExNotData(any)).called(1);
          verifyNever(mockRepository.getExNotData());
        },
      );
    });
  });
}
