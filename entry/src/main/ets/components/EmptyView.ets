@Component
export struct EmptyView {
  @Prop title: string = '暂无数据';
  @Prop description: string = '';

  build() {
    Column() {
      Text(this.title)
        .fontSize(18)
        .fontColor('#666666')

      if (this.description.length > 0) {
        Text(this.description)
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 8 })
      }
    }
    .width('100%')
    .padding(24)
    .alignItems(HorizontalAlign.Center)
  }
}