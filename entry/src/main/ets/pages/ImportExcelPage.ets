@Entry
@Component
struct ImportExcelPage {
  build() {
    Column() {
      Text('Excel 导入')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin(16)
      Text('该页面已预留，后续接入文件 Picker 和 xlsx 解析库。')
        .fontSize(15)
        .fontColor('#666666')
        .padding(16)
    }
  }
}
