import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CategoryUnitService } from '../services/CategoryUnitService';
import { CategoryUnit } from '../models/CategoryUnit';

@Entry
@Component
struct CategoryUnitListPage {
  private service: CategoryUnitService = new CategoryUnitService();

  @State list: CategoryUnit[] = [];
  @State loading: boolean = false;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;

    try {
      this.list = await this.service.getAll();
    } catch (e) {
      promptAction.showToast({ message: '加载分类失败' });
      console.error('load category unit failed:', e);
    }

    this.loading = false;
  }

  async deleteItem(id: string): Promise<void> {
    try {
      await this.service.delete(id);
      promptAction.showToast({ message: '删除成功' });
      await this.loadData();
    } catch (e) {
      promptAction.showToast({ message: '删除失败' });
      console.error('delete category unit failed:', e);
    }
  }

  build() {
    Column() {
      Row() {
        Text('分类管理')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button('新增')
          .onClick(() => {
            router.pushUrl({ url: 'pages/CategoryUnitCreatePage' });
          })
      }
      .width('100%')
      .padding(12)

      if (this.loading) {
        Text('加载中...')
          .fontSize(14)
          .fontColor('#888888')
      }

      if (!this.loading && this.list.length === 0) {
        Text('暂无分类数据')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 20 })
      }

      List() {
        ForEach(this.list, (item: CategoryUnit) => {
          ListItem() {
            Column() {
              Row() {
                Text(item.categoryName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .layoutWeight(1)

                Text(item.isEnabled ? '启用' : '禁用')
                  .fontSize(12)
                  .fontColor(item.isEnabled ? '#4CAF50' : '#999999')
              }

              Text('单位：' + item.unitOptions.join(' / '))
                .fontSize(12)
                .fontColor('#666666')
                .margin({ top: 4 })

              Text('默认：' + item.defaultUnit)
                .fontSize(12)
                .fontColor('#666666')

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
                    await this.deleteItem(item.id);
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