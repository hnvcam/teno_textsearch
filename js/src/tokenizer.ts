import _ from 'lodash';

class Tokenizer {
    minChars: number;
    maxChars: number;
    delimiter: string;
    caseSensitive: boolean;

    constructor({ minChars = 3, maxChars = 64, delimiter = ' ', caseSensitive = false }) {
        this.minChars = minChars;
        this.maxChars = maxChars;
        this.delimiter = delimiter;
        this.caseSensitive = caseSensitive;
    }

    process(input: string) {
        const words = input.split(this.delimiter);
        return _.uniq(_.flatMap(words, (word) => this._processWord(word)));
    }

    _processWord(word: string): Array<string> {
        const element = this.caseSensitive ? word : word.toLowerCase();
        const results = new Array<string>();
        const effectiveMaxChars = Math.min(this.maxChars, element.length);

        for (let charCount = this.minChars; charCount <= effectiveMaxChars; charCount++) {
            let forwardedPos = 0;
            let reversedPos = element.length;

            while (forwardedPos + charCount <= reversedPos) {
                if (forwardedPos + charCount <= reversedPos) {
                    results.push(element.substring(forwardedPos, forwardedPos + charCount));
                }

                if (reversedPos - charCount > forwardedPos) {
                    results.push(element.substring(reversedPos - charCount, reversedPos));
                }

                forwardedPos++;
                reversedPos--;
            }
        }

        return results;
    }
}

export default Tokenizer;
