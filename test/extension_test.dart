import 'package:teno_textsearch/src/extension.dart';
import 'package:test/test.dart';

main() {
  test('pick on first level property', () {
    final map = {'field1': 'value1', 'field2': 'value2', 'field3': 'value3'};
    expect(map.pick(['field1', 'field3']),
        {'field1': 'value1', 'field3': 'value3'});
  });

  test('pick on second level property', () {
    final map = {
      'field1': {'field11': 11},
      'field2': {'field21': 21, 'field22': 22}
    };
    expect(map.pick(['field1.field11', 'field2.field22']),
        {'field11': 11, 'field22': 22});
  });

  test('pick on non-exist first level property', () {
    final map = {'field1': 'value1', 'field2': 'value2', 'field3': 'value3'};
    expect(map.pick(['field4']), {});
  });

  test('pick on non-exist second level property', () {
    final map = {
      'field1': {'field11': 11},
      'field2': {'field21': 21, 'field22': 22}
    };
    expect(map.pick(['field3', 'field1.field12', 'field2.field22']),
        {'field22': 22});
  });
}
