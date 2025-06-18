import 'package:flutter_test/flutter_test.dart';
import 'package:pill_line_a_i/features/ex_notdata/domain/entities/ex_notdata.dart';

void main() {
  group('ExNotData', () {
    test('should create ExNotData with correct properties', () {
      const message = 'Test message';
      const type = 'test_type';
      const details = {'key': 'value', 'number': 123};

      const exNotData = ExNotData(
        message: message,
        type: type,
        details: details,
      );

      expect(exNotData.message, message);
      expect(exNotData.type, type);
      expect(exNotData.details, details);
    });

    test('should be equal when properties are the same', () {
      const exNotData1 = ExNotData(
        message: 'Test',
        type: 'type',
        details: {'key': 'value'},
      );

      const exNotData2 = ExNotData(
        message: 'Test',
        type: 'type',
        details: {'key': 'value'},
      );

      expect(exNotData1, equals(exNotData2));
    });

    test('should not be equal when properties are different', () {
      const exNotData1 = ExNotData(
        message: 'Test1',
        type: 'type',
        details: {'key': 'value'},
      );

      const exNotData2 = ExNotData(
        message: 'Test2',
        type: 'type',
        details: {'key': 'value'},
      );

      expect(exNotData1, isNot(equals(exNotData2)));
    });

    test('props should contain all properties', () {
      const exNotData = ExNotData(
        message: 'Test message',
        type: 'test_type',
        details: {'key': 'value'},
      );

      expect(
          exNotData.props,
          containsAll([
            'Test message',
            'test_type',
            {'key': 'value'}
          ]));
    });
  });
}
