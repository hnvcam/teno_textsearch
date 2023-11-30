import 'package:teno_textsearch/src/sinks.dart';

import 'extension.dart';
import 'index_map.dart';
import 'tokenizer.dart';

class SearchResult {
  final String key;
  final String field;
  const SearchResult(this.key, this.field);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return (other is SearchResult) && other.key == key && other.field == field;
  }

  @override
  int get hashCode => Object.hash(key, field);

  @override
  String toString() {
    return 'SearchResult(key: $key, field: $field)';
  }
}

class TenoTextSearch {
  late Tokenizer _tokenizer;
  late IndexMap _indexMap;
  final String indexKey;
  final List<String> indexFields;
  final bool caseSensitive;
  final bool forwardedOnly;

  TenoTextSearch({
    int minChars = 3,
    int maxChars = 32,
    String wordDelimiter = ' ',
    this.caseSensitive = false,
    this.forwardedOnly = true,
    required this.indexKey,
    required this.indexFields,
  }) {
    _tokenizer = Tokenizer(
        minChars: minChars,
        maxChars: maxChars,
        delimiter: wordDelimiter,
        forwardedOnly: forwardedOnly,
        caseSensitive: caseSensitive);
    _indexMap = IndexMap(tokenizer: _tokenizer, fields: indexFields);
  }

  void index(Map<String, dynamic> json) {
    final key = json[indexKey];
    assert(key?.isNotEmpty == true, 'Index key must exist in json');
    final mappedJson = json.pick(indexFields);
    if (mappedJson.isNotEmpty) {
      _indexMap.add(key, mappedJson);
    }
  }

  Iterable<SearchResult> search(String text) {
    final words = text.split(_tokenizer.delimiter);
    final result = words.flatMap((element) =>
        _indexMap.find(caseSensitive ? element : element.toLowerCase()) ??
        <List<int>>[]);
    return result.map(
        (e) => SearchResult(_indexMap.keyOf(e[0]), _indexMap.fieldOf(e[1])));
  }

  exportIndexToFile(String path) {
    final fileSink = FileSink(path);
    _indexMap.export(fileSink);
  }

  importFromJson(Map<String, dynamic> json) {
    _indexMap.import(json);
  }
}
