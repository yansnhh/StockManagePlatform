@Entry
@Component
struct TestPage {

  build() {
    Column() {

      Text('🎉 HarmonyOS 页面正常运行')

      Text('如果你看到这个页面，说明环境完全OK')

      Button('点击测试')
        .onClick(() => {
          console.info('button clicked')
        })

    }
    .width('100%')
    .height('100%')
  }
}