import 'package:test/test.dart';
import 'package:structlog/structlog.dart';
import 'package:structlog/filters.dart' show MultiFilter;
import 'package:structlog/src/record_impl.dart';

class _TestFilter1 extends Filter {
  @override
  bool filter(Record record) => record.name == 'Test';
}

class _TestFilter2 extends Filter {
  @override
  bool filter(Record record) => record.message == 'Test';
}

void main() {
  group('MultiFilter', () {
    test('allows any record when no filters set', () {
      final filter = MultiFilter([]);

      final record1 = RecordImpl(
          timestamp: DateTime.now(),
          name: 'abc',
          level: Level.info,
          message: 'abc',
          fields: []);
      final record2 = RecordImpl(
          timestamp: DateTime.now(),
          name: 'cba',
          level: Level.info,
          message: 'baz',
          fields: []);
      final record3 = RecordImpl(
          timestamp: DateTime.now(),
          name: 'foo',
          level: Level.info,
          message: 'bar',
          fields: []);

      expect(filter.filter(record1), isTrue);
      expect(filter.filter(record2), isTrue);
      expect(filter.filter(record3), isTrue);
    });

    test('delegates record to all filters', () {
      final filter1 = _TestFilter1();
      final filter2 = _TestFilter2();
      final filter = MultiFilter({filter1, filter2});

      final record1 = RecordImpl(
          timestamp: DateTime.now(),
          name: 'Test',
          level: Level.info,
          message: 'Test',
          fields: []);
      final record2 = RecordImpl(
          timestamp: DateTime.now(),
          name: 'Test',
          level: Level.info,
          message: 'Test2',
          fields: []);
      final record3 = RecordImpl(
          timestamp: DateTime.now(),
          name: 'Test2',
          level: Level.info,
          message: 'Test',
          fields: []);


      expect(filter.filter(record1), isTrue);
      expect(filter.filter(record2), isFalse);
      expect(filter.filter(record3), isFalse);
    });
  });
}