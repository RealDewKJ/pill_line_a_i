import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';

import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';
import 'package:pill_line_a_i/features/ex_notdata/data/datasources/ex_notdata_remote_data_source.dart';
import 'package:pill_line_a_i/features/ex_notdata/data/repositories/ex_notdata_repository_impl.dart';

import 'ex_notdata_repository_impl_test.mocks.dart';

@GenerateMocks([ExNotDataRemoteDataSource])
void main() {
  group('ExNotDataRepositoryImpl', () {
    late MockExNotDataRemoteDataSource mockRemoteDataSource;
    late ExNotDataRepositoryImpl repository;

    setUp(() {
      mockRemoteDataSource = MockExNotDataRemoteDataSource();
      repository = ExNotDataRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    });

    group('getExNotData', () {
      test('should return ExNotData when remote data source is successful', () async {
        // arrange
        const testExNotData = ExNotData(
          message: 'Test message',
          type: 'test',
          details: {'key': 'value'},
        );
        when(mockRemoteDataSource.getExNotData()).thenAnswer((_) async => testExNotData);

        // act
        final result = await repository.getExNotData();

        // assert
        expect(result, Right(testExNotData));
        verify(mockRemoteDataSource.getExNotData()).called(1);
      });

      test('should return Exception when remote data source throws exception', () async {
        // arrange
        when(mockRemoteDataSource.getExNotData()).thenThrow(Exception('Network error'));

        // act
        final result = await repository.getExNotData();

        // assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<Exception>());
        verify(mockRemoteDataSource.getExNotData()).called(1);
      });
    });

    group('updateExNotData', () {
      test('should return void when remote data source is successful', () async {
        // arrange
        const testExNotData = ExNotData(
          message: 'Update message',
          type: 'update',
          details: {'updated': true},
        );
        when(mockRemoteDataSource.updateExNotData(testExNotData)).thenAnswer((_) async => null);

        // act
        final result = await repository.updateExNotData(testExNotData);

        // assert
        expect(result, const Right(null));
        verify(mockRemoteDataSource.updateExNotData(testExNotData)).called(1);
      });

      test('should return Exception when remote data source throws exception', () async {
        // arrange
        const testExNotData = ExNotData(
          message: 'Update message',
          type: 'update',
          details: {'updated': true},
        );
        when(mockRemoteDataSource.updateExNotData(testExNotData)).thenThrow(Exception('Update failed'));

        // act
        final result = await repository.updateExNotData(testExNotData);

        // assert
        expect(result.isLeft(), true);
        expect(result.fold((l) => l, (r) => null), isA<Exception>());
        verify(mockRemoteDataSource.updateExNotData(testExNotData)).called(1);
      });
    });
  });
}
