/**
 * 使用本仓库 Markdown 解析引擎的样例（JavaScript）
 * 运行：npx tsx example.js
 */

import { marked, parseInline, lexer, walkTokens } from './index';

// 1. Markdown 转 HTML（完整块级+行内）
const md = `
# 标题示例

这是一段**粗体**和*斜体*文字。

- 列表项 A
- 列表项 B

[链接](https://example.com)

\`\`\`js
console.log('code block111111111');
\`\`\`
`;

console.log('=== marked() 输出 ===');
console.log(marked(md));

// 2. 仅行内解析（不包在 <p> 里）
console.log('\n=== parseInline() 输出 ===');
console.log(parseInline('**粗体** 与 [链接](https://example.com)'));

// 3. 仅做词法分析，得到 Token 列表
// console.log('\n=== lexer() 前 3 个 token ===');
// const tokens = lexer('# Hello\n\nworld');
// tokens.slice(0, 3).forEach((t, i) => console.log(i, t.type, t));

// // 4. 遍历 Token（例如统计标题数量）
// let headingCount = 0;
// walkTokens(tokens, (token) => {
//   if (token.type === 'heading') headingCount++;
// });
// console.log('\n=== walkTokens：标题数量 ===');
// console.log(headingCount);
