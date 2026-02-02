import { _defaults } from './defaults';
import { _Lexer } from './Lexer';
import { _Parser } from './Parser';
import type { MarkedOptions } from './MarkedOptions';
import type { Token, TokensList } from './Tokens';

export class _Hooks<ParserOutput = string, RendererOutput = string> {
  options: MarkedOptions<ParserOutput, RendererOutput>;
  block?: boolean;

  constructor(options?: MarkedOptions<ParserOutput, RendererOutput>) {
    this.options = options || _defaults;
  }

  static passThroughHooks = new Set([
    'preprocess',
    'postprocess',
    'processAllTokens',
    'emStrongMask',
  ]);

  static passThroughHooksRespectAsync = new Set([
    'preprocess',
    'postprocess',
    'processAllTokens',
  ]);

  /**
   * Process markdown before marked
   */
  preprocess(markdown: string) {
    return markdown;
  }

  /**
   * Process HTML after marked is finished
   */
  postprocess(html: ParserOutput) {
    return html;
  }

  /**
   * Process all tokens before walk tokens
   */
  processAllTokens(tokens: Token[] | TokensList) {
    return tokens;
  }

  /**
   * Mask contents that should not be interpreted as em/strong delimiters
   */
  emStrongMask(src: string) {
    return src;
  }

  /**
   * Provide function to tokenize markdown
   */
  provideLexer() {
    return this.block ? _Lexer.lex : _Lexer.lexInline;
  }

  /**
   * Provide function to parse tokens
   */
  provideParser() {
    return this.block ? _Parser.parse : _Parser.parseInline;
  }
}