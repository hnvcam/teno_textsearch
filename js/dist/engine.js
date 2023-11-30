"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TenoTextSearch = exports.SearchResult = void 0;
const tokenizer_1 = __importDefault(require("./tokenizer"));
const index_map_1 = __importDefault(require("./index_map"));
class SearchResult {
    constructor(key, field) {
        this.key = key;
        this.field = field;
    }
    equals(other) {
        return other instanceof SearchResult && other.key === this.key && other.field === this.field;
    }
    toString() {
        return `SearchResult(key: ${this.key}, field: ${this.field})`;
    }
}
exports.SearchResult = SearchResult;
class TenoTextSearch {
    constructor({ minChars = 3, maxChars = 32, wordDelimiter = ' ', caseSensitive = false, indexKey, indexFields, }) {
        this._tokenizer = new tokenizer_1.default({
            minChars,
            maxChars,
            delimiter: wordDelimiter,
            caseSensitive,
        });
        this._indexMap = new index_map_1.default({ tokenizer: this._tokenizer, fields: indexFields });
        this.indexKey = indexKey;
        this.indexFields = indexFields;
        this.caseSensitive = caseSensitive;
    }
    index(json) {
        const key = json[this.indexKey];
        if (key && typeof key === 'string' && key.length > 0) {
            const mappedJson = {};
            for (const field of this.indexFields) {
                if (json.hasOwnProperty(field)) {
                    mappedJson[field] = json[field];
                }
            }
            if (Object.keys(mappedJson).length > 0) {
                this._indexMap.add(key, mappedJson);
            }
        }
    }
    search(text) {
        const words = text.split(this._tokenizer.delimiter);
        const result = [];
        for (const word of words) {
            const element = this.caseSensitive ? word : word.toLowerCase();
            const found = this._indexMap.find(element);
            if (found) {
                result.push(...found);
            }
        }
        return result.map((e) => new SearchResult(this._indexMap.keyOf(e[0]), this._indexMap.fieldOf(e[1])));
    }
    exportIndex() {
        return this._indexMap.export();
    }
    importFromJson(json) {
        this._indexMap.import(json);
    }
}
exports.TenoTextSearch = TenoTextSearch;
