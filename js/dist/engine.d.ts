import { DocPropIndex } from './index_map';
declare class SearchResult {
    readonly key: string;
    readonly field: string;
    constructor(key: string, field: string);
    equals(other: unknown): boolean;
    toString(): string;
}
declare class TenoTextSearch {
    private _tokenizer;
    private _indexMap;
    readonly indexKey: string;
    readonly indexFields: string[];
    readonly caseSensitive: boolean;
    constructor({ minChars, maxChars, wordDelimiter, caseSensitive, indexKey, indexFields, }: {
        minChars?: number;
        maxChars?: number;
        wordDelimiter?: string;
        caseSensitive?: boolean;
        indexKey: string;
        indexFields: string[];
    });
    index(json: Record<string, unknown>): void;
    search(text: string): SearchResult[];
    exportIndex(): string;
    importFromJson(json: {
        keys: string[];
        data: Record<string, DocPropIndex[]>;
        fields: string[];
    }): void;
}
export { SearchResult, TenoTextSearch };
