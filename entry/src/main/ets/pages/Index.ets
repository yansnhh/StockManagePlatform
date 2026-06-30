@Entry
@Component
struct Index {

  build() {
    Column() {

      Text('库存管理系统')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 60 })

      Text('App 已成功运行')
        .fontSize(16)
        .margin({ top: 20 })

      Button('新增商品')
        .margin({ top: 30 })

    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}