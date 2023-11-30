declare class Tokenizer {
    minChars: number;
    maxChars: number;
    delimiter: string;
    caseSensitive: boolean;
    constructor({ minChars, maxChars, delimiter, caseSensitive }: {
        minChars?: number | undefined;
        maxChars?: number | undefined;
        delimiter?: string | undefined;
        caseSensitive?: boolean | undefined;
    });
    process(input: string): string[];
    _processWord(word: string): Array<string>;
}
export default Tokenizer;
