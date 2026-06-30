import router from '@ohos.router';
import { CategoryUnitService } from '../services/CategoryUnitService';
import { CategoryUnit } from '../models/CategoryUnit';

@Entry
@Component
struct CategoryUnitListPage {

  private service: CategoryUnitService = new CategoryUnitService();

  @State list: Array<CategoryUnit> = new Array<CategoryUnit>();
  @State loading: boolean = false;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;
    this.list = await this.service.getAll();
    this.loading = false;
  }

  build() {
    Column() {

      // ===== 顶部 =====
      Row() {
        Text('分类管理')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button('新增')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/CategoryUnitCreatePage'
            });
          })
      }
      .width('100%')
      .padding(12)

      // ===== loading =====
      if (this.loading) {
        Text('加载中...')
          .fontSize(14)
          .fontColor('#888')
      }

      // ===== 空状态 =====
      if (!this.loading && this.list.length === 0) {
        Text('暂无分类数据')
          .fontSize(14)
          .fontColor('#999')
          .margin({ top: 20 })
      }

      // ===== 列表 =====
      List() {
        ForEach(this.list, (item: CategoryUnit) => {
          ListItem() {
            Column() {

              // 标题行
              Row() {
                Text(item.categoryName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .layoutWeight(1)

                Text(item.isEnabled ? '启用' : '禁用')
                  .fontSize(12)
                  .fontColor(item.isEnabled ? '#4CAF50' : '#999')
              }

              // 单位
              Text('单位: ' + item.unitOptions.join(' / '))
                .fontSize(12)
                .fontColor('#666')
                .margin({ top: 4 })

              // 默认单位
              Text('默认: ' + item.defaultUnit)
                .fontSize(12)
                .fontColor('#666')

              // 操作区
              Row() {
                Button('编辑')
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/CategoryUnitEditPage',
                      params: { id: item.id }
                    });
                  })

                Button('删除')
                  .margin({ left: 10 })
                  .backgroundColor('#ff4d4f')
                  .onClick(async () => {
                    await this.service.delete(item.id);
                    await this.loadData();
                  })
              }
              .margin({ top: 8 })

            }
            .padding(12)
            .width('100%')
          }
        }, (item: CategoryUnit) => item.id)
      }
      .layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .padding(12)
  }
}