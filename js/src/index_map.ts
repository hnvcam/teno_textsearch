import _ from "lodash";
import Tokenizer from "./tokenizer";

export type DocPropIndex = number[];

class IndexMap {
  private _data: Record<string, DocPropIndex[]> = {};
  private _keys: string[] = [];
  private _effectiveFields: string[] = [];
  private readonly tokenizer: Tokenizer;

  constructor({ tokenizer, fields = [] }: { tokenizer: Tokenizer; fields?: string[] }) {
    this.tokenizer = tokenizer;

    if (fields.length > 0) {
      this._effectiveFields.push(...fields);
    }
  }

  add(key: string, document: Record<string, any>): void {
    this._keys.push(key);

    _.forEach(document, (value, key) => {
        if (typeof value !== 'string' || (this._effectiveFields.length > 0 && !_.includes(this._effectiveFields, key))) {
        return;
      }
      const tokens = this.tokenizer.process(value);
      let index = this._effectiveFields.indexOf(key);

      if (index < 0 && this._effectiveFields.length === 0) {
        this._effectiveFields.push(key);
        index = this._effectiveFields.length - 1;
      }
      _.forEach(tokens, (token) => {
        const indexedPropertyDocs = _.get(this._data, token, [] as Array<DocPropIndex>);
        indexedPropertyDocs.push([this._keys.length - 1, index]);
        this._data[token] = indexedPropertyDocs;
      });
    });
  }

  export(): string {
    return JSON.stringify({
        keys: this._keys, data: this._data, fields: this._effectiveFields
    });
  }

  import(json: { keys: string[]; data: Record<string, DocPropIndex[]>; fields: string[] }): void {
    this._keys.push(...json.keys);
    Object.assign(this._data, json.data);
    this._effectiveFields.push(...json.fields);
  }

  find(word: string): DocPropIndex[] | undefined {
    return this._data[word];
  }

  keyOf(docIndex: number): string {
    return this._keys[docIndex];
  }

  fieldOf(fieldIndex: number): string {
    return this._effectiveFields[fieldIndex];
  }
}

export default IndexMap;