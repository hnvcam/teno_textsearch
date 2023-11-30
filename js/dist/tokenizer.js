"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = __importDefault(require("lodash"));
class Tokenizer {
    constructor({ minChars = 3, maxChars = 64, delimiter = ' ', caseSensitive = false }) {
        this.minChars = minChars;
        this.maxChars = maxChars;
        this.delimiter = delimiter;
        this.caseSensitive = caseSensitive;
    }
    process(input) {
        const words = input.split(this.delimiter);
        return lodash_1.default.uniq(lodash_1.default.flatMap(words, (word) => this._processWord(word)));
    }
    _processWord(word) {
        const element = this.caseSensitive ? word : word.toLowerCase();
        const results = new Array();
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
exports.default = Tokenizer;
