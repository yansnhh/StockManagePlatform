import router from '@ohos.router';
import { CustomField } from '../models/CustomField';
import { CustomFieldService } from '../services/CustomFieldService';

@Entry
@Component
struct CustomFieldListPage {
  private service: CustomFieldService = new CustomFieldService();
  @State fields: CustomField[] = [];

  aboutToAppear() {
    this.load();
  }

  async load() {
    this.fields = await this.service.getAllFields();
  }

  build() {
    Column() {
      Row() {
        Button('返回').height(36).onClick(() => router.back())
        Text('自定义字段')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)
        Button('新增').height(36).onClick(() => router.pushUrl({ url: 'pages/CustomFieldEditPage' }))
      }
      .padding(16)

      if (this.fields.length === 0) {
        Text('暂无自定义字段')
          .fontSize(14)
          .fontColor('#888888')
          .margin({ top: 40 })
      } else {
        List({ space: 12 }) {
          ForEach(this.fields, (item: CustomField) => {
            ListItem() {
              Column() {
                Text(item.fieldName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                Text(`类型：${item.fieldType}；枚举：${item.enumOptions.join('、') || '--'}`)
                  .fontSize(12)
                  .fontColor('#666666')
                  .margin({ top: 4 })
                Text(item.isEnabled ? '已启用' : '已停用')
                  .fontSize(12)
                  .fontColor(item.isEnabled ? '#2A7E3B' : '#999999')
                  .margin({ top: 4 })
              }
              .padding(16)
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(12)
            }
          }, (item: CustomField) => item.id)
        }
        .padding({ left: 16, right: 16 })
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
