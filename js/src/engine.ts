import Tokenizer from './tokenizer'; 
import IndexMap, { DocPropIndex } from './index_map';

class SearchResult {
  readonly key: string;
  readonly field: string;

  constructor(key: string, field: string) {
    this.key = key;
    this.field = field;
  }

  equals(other: unknown): boolean {
    return other instanceof SearchResult && other.key === this.key && other.field === this.field;
  }

  toString(): string {
    return `SearchResult(key: ${this.key}, field: ${this.field})`;
  }
}

class TenoTextSearch {
  private _tokenizer: Tokenizer;
  private _indexMap: IndexMap;
  readonly indexKey: string;
  readonly indexFields: string[];
  readonly caseSensitive: boolean;

  constructor({
    minChars = 3,
    maxChars = 32,
    wordDelimiter = ' ',
    caseSensitive = false,
    indexKey,
    indexFields,
  }: {
    minChars?: number;
    maxChars?: number;
    wordDelimiter?: string;
    caseSensitive?: boolean;
    indexKey: string;
    indexFields: string[];
  }) {
    this._tokenizer = new Tokenizer({
      minChars,
      maxChars,
      delimiter: wordDelimiter,
      caseSensitive,
    });
    this._indexMap = new IndexMap({ tokenizer: this._tokenizer, fields: indexFields });
    this.indexKey = indexKey;
    this.indexFields = indexFields;
    this.caseSensitive = caseSensitive;
  }

  index(json: Record<string, unknown>): void {
    const key = json[this.indexKey];
    if (key && typeof key === 'string' && key.length > 0) {
      const mappedJson: Record<string, unknown> = {};
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

  search(text: string): SearchResult[] {
    const words = text.split(this._tokenizer.delimiter);
    const result: DocPropIndex[] = [];
    for (const word of words) {
      const element = this.caseSensitive ? word : word.toLowerCase();
      const found = this._indexMap.find(element);
      if (found) {
        result.push(...found);
      }
    }
    return result.map((e) => new SearchResult(this._indexMap.keyOf(e[0]), this._indexMap.fieldOf(e[1])));
  }

  exportIndex(): string {
    return this._indexMap.export();
  }

  importFromJson(json: { keys: string[]; data: Record<string, DocPropIndex[]>; fields: string[] }): void {
    this._indexMap.import(json);
  }
}

export { SearchResult, TenoTextSearch };
