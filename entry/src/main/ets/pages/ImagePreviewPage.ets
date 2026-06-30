import router from '@ohos.router';

@Entry
@Component
struct ImagePreviewPage {
  @State uri: string = '';

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    this.uri = params?.uri || '';
  }

  build() {
    Column() {
      Row() {
        Button('返回').height(36).onClick(() => router.back())
        Text('图片预览')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .padding(16)

      if (this.uri.length > 0) {
        Image(this.uri)
          .width('100%')
          .layoutWeight(1)
          .objectFit(ImageFit.Contain)
      } else {
        Text('图片不存在或地址失效')
          .fontSize(16)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}
