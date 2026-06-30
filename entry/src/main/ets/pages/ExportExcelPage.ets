@Entry
@Component
struct ExportExcelPage {
  build() {
    Column() {
      Text('Excel 导出')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .margin(16)
      Text('该页面已预留，后续接入 xlsx 生成库和文件保存能力。')
        .fontSize(15)
        .fontColor('#666666')
        .padding(16)
    }
  }
}
