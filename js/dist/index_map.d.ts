import Tokenizer from "./tokenizer";
export type DocPropIndex = number[];
declare class IndexMap {
    private _data;
    private _keys;
    private _effectiveFields;
    private readonly tokenizer;
    constructor({ tokenizer, fields }: {
        tokenizer: Tokenizer;
        fields?: string[];
    });
    add(key: string, document: Record<string, any>): void;
    export(): string;
    import(json: {
        keys: string[];
        data: Record<string, DocPropIndex[]>;
        fields: string[];
    }): void;
    find(word: string): DocPropIndex[] | undefined;
    keyOf(docIndex: number): string;
    fieldOf(fieldIndex: number): string;
}
export default IndexMap;
