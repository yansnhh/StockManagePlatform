import router from '@ohos.router';

@Entry
@Component
struct SettingsPage {

  build() {
    Column() {
      Row(){
        Button('返回')
          .height(34)
          .onClick(() => {
            router.back();
          })

        Text('设置中心')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 20 })
      }

      // ===== 分类管理 =====
      this.item('分类管理', '管理商品分类与单位', () => {
        router.pushUrl({
          url: 'pages/CategoryUnitListPage'
        });
      })

      // ===== 自定义字段 =====
      // this.item('自定义字段', '扩展商品属性字段', () => {
      //   router.pushUrl({
      //     url: 'pages/CustomFieldListPage'
      //   });
      // })

      // ===== 导入导出 =====
      this.item('导入导出', 'JSON备份与恢复库存数据', () => {
        try {
          router.pushUrl({
            url: 'pages/DataManagePage'
          });
        } catch (e) {
          console.error('go data manage failed:', e);
        }
      })

    }
    .width('100%')
    .height('100%')
    .padding(16)
  }

  @Builder
  item(title: string, desc: string, onClick: () => void) {
    Column() {
      Row() {
        Column() {
          Text(title)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)

          Text(desc)
            .fontSize(12)
            .fontColor('#888')
        }
        .layoutWeight(1)

        Text('>')
          .fontSize(18)
          .fontColor('#999')
      }
      .padding(12)
      .width('100%')
      .backgroundColor('#F5F5F5')
      .borderRadius(10)
    }
    .margin({ bottom: 12 })
    .onClick(onClick)
  }
}