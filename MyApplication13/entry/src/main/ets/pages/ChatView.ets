import { KeyboardAvoidMode } from '@kit.ArkUI'

@Observed
export class MessageBean {
  leftMessage?: string
  rightMessage?: string
}

@Component
export struct ChatView {
  @ObjectLink messageBean: MessageBean;

  build() {
    Column() {
      if (this.messageBean.rightMessage != undefined) {
        Row() {
          Text(this.messageBean.rightMessage)
            .margin({ right: 10 })
          Image($r("app.media.startIcon"))
            .id("user_logo")
            .border({ color: Color.Red, width: 1, radius: 20 })
            .width(20)
            .height(20)
        }.width("100%")
        .justifyContent(FlexAlign.End)
        .padding({ right: 10 })
      } else {
        Row() {
          Image($r("app.media.startIcon"))
            .border({ color: Color.Red, width: 1, radius: 20 })
            .width(20)
            .height(20)
          Text(this.messageBean.leftMessage)
            .margin({ left: 10 })
        }.alignItems(VerticalAlign.Top)
        .padding({ right: 20 })
      }

    }
  }
}

@Entry
@Component
struct Index {
  private scroller: Scroller = new Scroller()
  @State sendMessage: string = ""
  @State messageList: MessageBean[] = []
  intervalID?: number
  private isEnd: boolean = true

  aboutToAppear(): void {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }

  /**
   *AUTHOR:AbnerMing
   *INTRODUCE:模拟请求网络接口
   */
  doHttp(success: (message: string) => void) {
    let data = "具体的实现效果，根据业务情况而定，有两种模式，一种主动的流式输出，也就是数据以流式的形式进行返回，前端直接用组件加载即可，第二种就是刻意的流式展示，也就是在拿到数据之后，前端实现流式输出，进行打字机展示。"
    let position: number = 0
    //模拟请求流式输出
    this.intervalID = setInterval(() => {
      position = position + 2
      let message = data.substring(0, position)
      if (success != undefined) {
        success(message)
      }
      if (message.length >= data.length) {
        this.isEnd = true //模拟结束
        clearInterval(this.intervalID)
      }
    }, 100)
  }

  build() {
    RelativeContainer() {
      List({ space: 10, scroller: this.scroller }) {
        ForEach(this.messageList, (item: MessageBean) => {
          ListItem() {
            ChatView({ messageBean: item })
          }
        })
      }.margin({ top: 10 })
      .alignRules({
        top: {
          anchor: "__container__",
          align: VerticalAlign.Top
        },
        bottom: {
          anchor: "layout_send",
          align: VerticalAlign.Top
        }
      })

      RelativeContainer() {
        TextInput({ placeholder: "请输入问题" })
          .onChange((text) => {
            this.sendMessage = text
          })
          .alignRules({
            left: {
              anchor: "__container__",
              align: HorizontalAlign.Start
            },
            right: {
              anchor: "btn_send",
              align: HorizontalAlign.Start
            }
          })
        Button("发送")
          .id("btn_send")
          .margin({ left: 10 })
          .alignRules({
            right: {
              anchor: "__container__",
              align: HorizontalAlign.End
            }
          }).onClick(() => {
          //发送
          if (this.isEnd) {
            this.isEnd = false
            let bean = new MessageBean()
            bean.rightMessage = this.sendMessage
            this.messageList.push(bean)
            this.scroller.scrollEdge(Edge.Bottom)
            //模拟接口返回数据
            let leftBean = new MessageBean()
            this.messageList.push(leftBean)
            this.doHttp((content) => {
              leftBean.leftMessage = content
            })
          }

        })
      }
      .height(40)
      .id("layout_send")
      .padding({ left: 10, right: 10 })
      .backgroundColor(Color.White)
      .alignRules({
        bottom: {
          anchor: "__container__",
          align: VerticalAlign.Bottom
        }
      })
    }.width("100%")
    .height("100%")
  }
}