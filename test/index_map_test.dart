import 'package:teno_textsearch/src/index_map.dart';
import 'package:teno_textsearch/src/sinks.dart';
import 'package:teno_textsearch/src/tokenizer.dart';
import 'package:test/test.dart';

main() {
  test("export", () {
    final tokenizer = Tokenizer(forwardedOnly: false);
    final indexMap = IndexMap(tokenizer: tokenizer);
    indexMap.add('doc1', {'title': 'sample value', 'description': 'none'});
    indexMap.add('doc2', {'title': 'another one'});
    final buffer = StringBuffer();
    indexMap.export(StringBufferSink(buffer));
    expect(buffer.toString(),
        '{"keys":["doc1","doc2"],"data":{"sam":[[0,0]],"ple":[[0,0]],"amp":[[0,0]],"mpl":[[0,0]],"samp":[[0,0]],"mple":[[0,0]],"ampl":[[0,0]],"sampl":[[0,0]],"ample":[[0,0]],"sample":[[0,0]],"val":[[0,0]],"lue":[[0,0]],"alu":[[0,0]],"valu":[[0,0]],"alue":[[0,0]],"value":[[0,0]],"non":[[0,1]],"one":[[0,1],[1,0]],"none":[[0,1]],"ano":[[1,0]],"her":[[1,0]],"not":[[1,0]],"the":[[1,0]],"oth":[[1,0]],"anot":[[1,0]],"ther":[[1,0]],"noth":[[1,0]],"othe":[[1,0]],"anoth":[[1,0]],"other":[[1,0]],"nothe":[[1,0]],"anothe":[[1,0]],"nother":[[1,0]],"another":[[1,0]]},"fields":["title","description"]}');
  });
}
