import  {HmParseHTML} from "@wuyan/html_parse"
import { html2md } from "@luvi/html2md"
import { Markdown, MarkdownController } from "@luvi/lv-markdown-in"
import { promptAction } from "@kit.ArkUI";

@Entry
@Component
struct TestPage {
  scroller: Scroller = new Scroller();
  @State htmlStr:string =``
  @State html2mdResult: string = ""
  controller: MarkdownController = new MarkdownController()

  aboutToAppear(): void {
    setTimeout(()=>{
      // html2mdResult为转换后的md文本
      this.html2mdResult = html2md("<b>加粗文本</b> <br> <p>这是一个段落，<i>斜体</i>可以包含在其中。</p>  <text>测试</text> <a>a链接</a>")
      this.controller.setHyperlinkClickListener((src: string) => {
        console.log("拦截跳转 title: ") // 标题
        console.log("拦截跳转 src: " + src) // 网页地址
        promptAction.showToast({ message: '测试' + "\n" + src })
        return true
      })
      this.htmlStr=`
      <h1>h1标签</h1>
      <h2>h2标签</h2>
      <p>p标签</p>
      <a href="http://www.baidu.com">a标签</a>
      <img style="width: 750px;height: 500px;" src="https://img2.baidu.com/it/u=1544882228,2394903552&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500" />
      <img style="width: 750px;height: 500px;" src="https://img0.baidu.com/it/u=3422287847,344441285&fm=253&fmt=auto&app=138&f=JPEG?w=604&h=500" >
      <input style="color:red" placeholder="请输入..." type="number" maxlength="2" value="我是input标签"/>
      <div>无序列表</div>
      <ul>
        <li>无序列表1</li>
        <li>无序列表2</li>
      </ul>
      <p>有序列表</p>
      <ol>
        <li>有序列表1</li>
        <li>有序列表2</li>
      </ol>
     `
    },1000)
  }
  build() {
    Scroll(this.scroller) {
      // HmParseHTML({
      //   htmlStr:this.htmlStr,  // 富文本内容-必传
      // });
      Markdown({ text: this.html2mdResult })
    }
  }
}