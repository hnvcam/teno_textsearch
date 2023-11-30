import 'dart:convert';

import 'tokenizer.dart';

typedef DocPropIndex = List<int>;

class IndexMap {
  final Map<String, List<DocPropIndex>> _data = {};
  final List<String> _keys = [];
  final List<String> fields;
  final List<String> _effectiveFields = [];
  final Tokenizer tokenizer;

  IndexMap({required this.tokenizer, this.fields = const []}) {
    if (fields.isNotEmpty) {
      _effectiveFields.addAll(fields);
    }
  }

  void add(String key, Map<String, dynamic> document) {
    _keys.add(key);
    for (var entry in document.entries) {
      if (entry.value is! String ||
          (fields.isNotEmpty && !fields.contains(entry.key))) {
        continue;
      }
      final tokens = tokenizer.process(entry.value);
      int index = _effectiveFields.indexOf(entry.key);
      if (index < 0 && fields.isEmpty) {
        _effectiveFields.add(entry.key);
        index = _effectiveFields.length - 1;
      }
      for (String token in tokens) {
        final indexedPropertyDocs = _data[token] ?? [];
        indexedPropertyDocs.add([_keys.length - 1, index]);
        _data[token] = indexedPropertyDocs;
      }
    }
  }

  void export(Sink<String> sink) {
    final encoder = JsonEncoder();
    final chunk = encoder.startChunkedConversion(sink);
    chunk.add({'keys': _keys, 'data': _data, 'fields': _effectiveFields});
    chunk.close();
  }

  void import(Map<String, dynamic> json) {
    _keys.addAll(json['keys']);
    _data.addAll(json['data']);
    _effectiveFields.addAll(json['fields']);
  }

  List<DocPropIndex>? find(String word) {
    return _data[word];
  }

  String keyOf(int docIndex) {
    return _keys[docIndex];
  }

  String fieldOf(int fieldIndex) {
    return _effectiveFields[fieldIndex];
  }
}
