import 'package:teno_textsearch/src/tokenizer.dart';
import 'package:test/test.dart';

main() {
  group('tokenize single word, default config', () {
    const testData = [
      (input: 'te', expected: <String>{}),
      (input: 'tes', expected: {'tes'}),
      (input: 'test', expected: {'tes', 'est', 'test'}),
      (
        input: 'tokenizer',
        expected: {
          'tok',
          'zer',
          'oke',
          'ize',
          'ken',
          'niz',
          'eni',
          'toke',
          'izer',
          'oken',
          'nize',
          'keni',
          'eniz',
          'token',
          'nizer',
          'okeni',
          'enize',
          'keniz',
          'tokeni',
          'enizer',
          'okeniz',
          'kenize',
          'tokeniz',
          'kenizer',
          'okenize',
          'tokenize',
          'okenizer',
          'tokenizer'
        }
      )
    ];
    final tokenizer = Tokenizer();

    for (var data in testData) {
      test('tokenize ${data.input} return ${data.expected.length} token', () {
        print(
            'actual: ${tokenizer.process(data.input)}\n expect: ${data.expected}');
        expect(tokenizer.process(data.input), data.expected);
      });
    }
  });

  group('tokenize single word, min=4 max=5', () {
    const testData = [
      (input: 'te', expected: <String>{}),
      (input: 'tes', expected: <String>{}),
      (input: 'test', expected: {'test'}),
      (
        input: 'tokenizer',
        expected: {
          'toke',
          'izer',
          'oken',
          'nize',
          'keni',
          'eniz',
          'token',
          'nizer',
          'okeni',
          'enize',
          'keniz',
        }
      )
    ];
    final tokenizer = Tokenizer(minChars: 4, maxChars: 5);

    for (var data in testData) {
      test('tokenize ${data.input} return ${data.expected.length} token', () {
        print(
            'actual: ${tokenizer.process(data.input)}\n expect: ${data.expected}');
        expect(tokenizer.process(data.input), data.expected);
      });
    }
  });

  group('tokenize multiple word, min=4 max=5', () {
    const testData = [
      (
        input: 'tokenizer multiple word',
        expected: {
          'toke',
          'izer',
          'oken',
          'nize',
          'keni',
          'eniz',
          'token',
          'nizer',
          'okeni',
          'enize',
          'keniz',
          'mult',
          'iple',
          'ulti',
          'tipl',
          'ltip',
          'multi',
          'tiple',
          'ultip',
          'ltipl',
          'word'
        }
      )
    ];
    final tokenizer = Tokenizer(minChars: 4, maxChars: 5);

    for (var data in testData) {
      test('tokenize ${data.input} return ${data.expected.length} token', () {
        print(
            'actual: ${tokenizer.process(data.input)}\n expect: ${data.expected}');
        expect(tokenizer.process(data.input), data.expected);
      });
    }
  });
}
