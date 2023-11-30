"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const lodash_1 = __importDefault(require("lodash"));
class IndexMap {
    constructor({ tokenizer, fields = [] }) {
        this._data = {};
        this._keys = [];
        this._effectiveFields = [];
        this.tokenizer = tokenizer;
        if (fields.length > 0) {
            this._effectiveFields.push(...fields);
        }
    }
    add(key, document) {
        this._keys.push(key);
        lodash_1.default.forEach(document, (value, key) => {
            if (typeof value !== 'string' || (this._effectiveFields.length > 0 && !lodash_1.default.includes(this._effectiveFields, key))) {
                return;
            }
            const tokens = this.tokenizer.process(value);
            let index = this._effectiveFields.indexOf(key);
            if (index < 0 && this._effectiveFields.length === 0) {
                this._effectiveFields.push(key);
                index = this._effectiveFields.length - 1;
            }
            lodash_1.default.forEach(tokens, (token) => {
                const indexedPropertyDocs = lodash_1.default.get(this._data, token, []);
                indexedPropertyDocs.push([this._keys.length - 1, index]);
                this._data[token] = indexedPropertyDocs;
            });
        });
    }
    export() {
        return JSON.stringify({
            keys: this._keys, data: this._data, fields: this._effectiveFields
        });
    }
    import(json) {
        this._keys.push(...json.keys);
        Object.assign(this._data, json.data);
        this._effectiveFields.push(...json.fields);
    }
    find(word) {
        return this._data[word];
    }
    keyOf(docIndex) {
        return this._keys[docIndex];
    }
    fieldOf(fieldIndex) {
        return this._effectiveFields[fieldIndex];
    }
}
exports.default = IndexMap;
