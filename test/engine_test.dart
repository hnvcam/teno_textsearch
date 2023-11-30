import 'package:teno_textsearch/src/engine.dart';
import 'package:test/test.dart';

main() {
  test('Search for single word', () {
    final engine = TenoTextSearch(indexKey: 'id', indexFields: ['title']);
    engine.index({
      'id': 'doc1',
      'title': 'First document',
      'description': 'no description'
    });
    engine.index({'id': 'doc2', 'title': 'Second document'});
    expect(engine.search('document'),
        [SearchResult('doc1', 'title'), SearchResult('doc2', 'title')]);
    expect(engine.search('second'), [SearchResult('doc2', 'title')]);
  });
}
