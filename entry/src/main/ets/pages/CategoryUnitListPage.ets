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
  @State refreshVersion: number = 0;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async onPageShow(): Promise<void> {
    console.info('[CategoryUnitList] onPageShow');
    await this.loadData();
  }

  showToast(message: string): void {
    try {
      promptAction.showToast({ message });
    } catch (e) {
      console.error('showToast failed:', e);
    }
  }

  goCreate(): void {
    try {
      router.pushUrl({ url: 'pages/CategoryUnitCreatePage' });
    } catch (e) {
      console.error('go create failed:', e);
    }
  }

  goEdit(id: string): void {
    try {
      router.pushUrl({
        url: 'pages/CategoryUnitEditPage',
        params: { id }
      });
    } catch (e) {
      console.error('go edit failed:', e);
    }
  }

  async loadData(): Promise<void> {
    this.loading = true;

    try {
      console.info('[CategoryUnitList] loadData start');

      const result: CategoryUnit[] = await this.service.getAll();

      this.list = [];
      this.list = [...result];

      this.refreshVersion = this.refreshVersion + 1;

      console.info('[CategoryUnitList] refreshVersion:', this.refreshVersion.toString());
      console.info('[CategoryUnitList] list state updated:', JSON.stringify(this.list));
    } catch (e) {
      this.showToast('加载分类失败');
      console.error('[CategoryUnitList] load failed:', e);
    }

    this.loading = false;
  }

  async deleteItem(id: string): Promise<void> {
    try {
      await this.service.delete(id);
      this.showToast('删除成功');
      await this.loadData();
    } catch (e) {
      this.showToast('删除失败');
      console.error('delete category unit failed:', e);
    }
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .height(34)
          .onClick(() => {
            router.back();
          })

        Text('分类管理')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)

        Button('新增')
          .onClick(() => {
            this.goCreate();
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

      Text(this.refreshVersion.toString())
        .width(0)
        .height(0)
        .opacity(0)

      List() {
        ForEach(this.list, (item: CategoryUnit) => {
          ListItem() {
            Column() {
              Row() {
                Text(item.categoryName)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .layoutWeight(1)
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
                    this.goEdit(item.id);
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
        }, (item: CategoryUnit) => item.id + '_' + item.updatedAt + '_' + this.refreshVersion.toString())
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding(12)
  }
}