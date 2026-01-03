import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import { ChatView } from './ChatView';
import { common } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';
import router from '@ohos.router'
const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State htmlContent: string = ''
  // Web组件的控制器，必需参数
  controller: webview.WebviewController = new webview.WebviewController()

  // 计算属性：生成完整的 data URL
  get dataUrl(): string {
    if (this.htmlContent) {
      return 'data:text/html;charset=utf-8,' + encodeURIComponent(this.htmlContent);
    }
    return '';
  }

  async aboutToAppear() {
    try {
      // 获取上下文，用于访问资源管理器
      // 注意：getContext 已被标记为 deprecated，但仍可使用以访问 resourceManager

      const context = getContext(this) as common.UIAbilityContext;
      // 读取 rawfile 中的 md 文件
      const resourceManager = context.resourceManager;
      const rawFileContent: Uint8Array = await resourceManager.getRawFileContent('example.md');
      console.log("rawFileContent", JSON.stringify(rawFileContent))
      
      // 将 Uint8Array 转换为字符串
      // 使用循环将每个字节转换为字符（适用于 UTF-8 编码的文本文件）
      let mdText: string = '';
      for (let i = 0; i < rawFileContent.length; i++) {
        mdText += String.fromCharCode(rawFileContent[i]);
        // console.log("rawFileContent mdText", JSON.stringify(mdText))
      }

      // 使用简单 Markdown 转 HTML（仅演示用）
      const htmlBody: string = mdText
        .replace(/^# (.*$)/gm, '<h1>$1</h1>')
        .replace(/^## (.*$)/gm, '<h2>$1</h2>')
        .replace(/\*\*(.*?)\*\*/g, '<b>$1</b>')
        .replace(/\*(.*?)\*/g, '<i>$1</i>')
        .replace(/```js([\s\S]*?)```/g, '<pre><code>$1</code></pre>')
        .replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2">$1</a>')
        .replace(/- (.*$)/gm, '<li>$1</li>')

      console.log("rawFileContent htmlBody", JSON.stringify(mdText))

      // 生成完整的 HTML 内容
      const fullHtml = `
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              body { font-family: sans-serif; padding: 20px; line-height: 1.6; }
              code { background: #f2f2f2; padding: 4px; border-radius: 3px; }
              pre { background: #f2f2f2; padding: 10px; border-radius: 5px; overflow-x: auto; }
              a { color: blue; }
              h1 { border-bottom: 2px solid #eee; padding-bottom: 10px; }
              h2 { border-bottom: 1px solid #eee; padding-bottom: 5px; }
            </style>
          </head>
          <body>${htmlBody}</body>
        </html>
      `
      
      // 更新 htmlContent，触发 UI 更新
      this.htmlContent = fullHtml.trim();
      hilog.info(DOMAIN, 'Index', 'HTML content loaded, length: %{public}d', this.htmlContent.length);
      hilog.info(DOMAIN, 'Index', 'HTML preview: %{public}s', this.htmlContent.substring(0, 100));
    } catch (err) {
      // 错误处理：如果文件读取失败，显示错误信息
      hilog.error(DOMAIN, 'Index', 'Failed to load markdown file: %{public}s', JSON.stringify(err));
      this.htmlContent = '<html><body><p>无法加载 Markdown 文件</p></body></html>';
    }
  }

  build() {
    Column() {
      // 标题和跳转按钮区域
      Row() {
        Text('Markdown 预览')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
        
        Blank()
        
        // 跳转到测试页面的按钮
        Button('测试页面')
          .type(ButtonType.Normal)
          .fontSize(14)
          .height(36)
          .onClick(() => {
            // 跳转到测试页面
            router.pushUrl({
              url: 'pages/TestPage'
            }).then(() => {
              hilog.info(DOMAIN, 'Index', 'Navigation to TestPage succeeded');
            }).catch((err: Error) => {
              hilog.error(DOMAIN, 'Index', 'Failed to navigate to TestPage: %{public}s', err.message);
            });
          })
      }
      .width('100%')
      .padding({ left: 0, right: 0, top: 0, bottom: 12 })

      // Web组件必须提供 controller 参数
      // 只有当 htmlContent 有内容时才渲染 Web 组件
      if (this.htmlContent) {
        Web({ src: this.dataUrl, controller: this.controller })
          .width('100%')
          .height('80%')
      } else {
        // 加载中的提示
        Text('加载中...')
          .fontSize(16)
          .fontColor(Color.Gray)
          .width('100%')
          .height('80%')
          .textAlign(TextAlign.Center)
      }
    }
    .width('100%')
    .backgroundColor(Color.Blue)
    .height('100%')
    .padding(20)
  }
}
