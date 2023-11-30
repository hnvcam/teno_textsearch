import 'dart:math';

import 'extension.dart';

class Tokenizer {
  final int minChars;
  final int maxChars;
  final String delimiter;
  final bool caseSensitive;
  final bool forwardedOnly;

  const Tokenizer(
      {this.minChars = 3,
      this.maxChars = 64,
      this.delimiter = ' ',
      this.caseSensitive = false,
      this.forwardedOnly = true});

  Set<String> process(String input) {
    final words = input.split(delimiter);
    return words.flatMap(_processWord).toSet();
  }

  Iterable<String> _processWord(String word) {
    final element = caseSensitive ? word : word.toLowerCase();
    final results = <String>{};
    final effectiveMaxChars = min(maxChars, element.length);
    for (int charCount = minChars;
        charCount <= effectiveMaxChars;
        charCount++) {
      if (forwardedOnly) {
        results.add(element.substring(0, charCount));
        continue;
      }

      int forwardedPos = 0;
      int reversedPos = element.length;
      while (forwardedPos + charCount <= reversedPos) {
        if (forwardedPos + charCount <= reversedPos) {
          results
              .add(element.substring(forwardedPos, forwardedPos + charCount));
        }
        // when reversedPos - charCount == forwardPos, we already added above.
        if (reversedPos - charCount > forwardedPos) {
          results.add(element.substring(reversedPos - charCount, reversedPos));
        }
        forwardedPos++;
        reversedPos--;
      }
    }
    return results;
  }
}
