import 'package:teno_textsearch/teno_textsearch.dart';

void main() {
  final engine = TenoTextSearch(indexKey: 'id', indexFields: ['title']);
  engine.index({
    'id': 'doc1',
    'title': 'First document',
    'description': 'no description'
  });
  engine.index({'id': 'doc2', 'title': 'Second document'});
  print(engine.search('document'));
}
