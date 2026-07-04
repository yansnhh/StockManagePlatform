import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Product } from '../models/Product';
import { ProductService } from '../services/ProductService';

@Entry
@Component
struct ProductListPage {
  private service: ProductService = new ProductService();

  @State list: Product[] = [];
  @State searchText: string = '';
  @State loading: boolean = false;
  @State refreshVersion: number = 0;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async onPageShow(): Promise<void> {
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
      router.pushUrl({ url: 'pages/ProductCreatePage' });
    } catch (e) {
      console.error('go create failed:', e);
    }
  }

  goEdit(id: string): void {
    try {
      router.pushUrl({
        url: 'pages/ProductEditPage',
        params: { id }
      });
    } catch (e) {
      console.error('go edit failed:', e);
    }
  }

  goSettings(): void {
    try {
      router.pushUrl({ url: 'pages/SettingsPage' });
    } catch (e) {
      console.error('go settings failed:', e);
    }
  }

  async loadData(): Promise<void> {
    this.loading = true;

    try {
      const result: Product[] = await this.service.getAll();
      this.list = [];
      this.list = [...result];
      this.refreshVersion = this.refreshVersion + 1;

      console.info('[ProductList] list state updated:', JSON.stringify(this.list));
    } catch (e) {
      this.showToast('加载商品失败');
      console.error('[ProductList] load failed:', e);
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
      console.error('[ProductList] delete failed:', e);
    }
  }

  getDisplayList(): Product[] {
    const keyword: string = this.searchText.trim();

    if (keyword.length === 0) {
      return this.list;
    }

    const result: Product[] = [];

    for (let i = 0; i < this.list.length; i++) {
      const item: Product = this.list[i];

      if (
        item.name.indexOf(keyword) !== -1 ||
          item.categoryName.indexOf(keyword) !== -1 ||
          item.remark.indexOf(keyword) !== -1
      ) {
        result.push(item);
      }
    }

    return result;
  }

  hasImage(uri: string): boolean {
    return uri !== undefined && uri.trim().length > 0;
  }

  getPlaceholderColor(id: string): string {
    const colors: string[] = [
      '#E6F0FF',
      '#FFF1E6',
      '#EFFFF2',
      '#F4EFFF',
      '#FFF7D6',
      '#FFEAEA'
    ];

    return colors[id.length % colors.length];
  }

  build() {
    Column() {
      Text(this.refreshVersion.toString())
        .width(0)
        .height(0)
        .opacity(0)

      Row() {
        TextInput({ placeholder: '搜索商品', text: this.searchText })
          .height(48)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.searchText = value;
          })

      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })

      Row() {
        Button('新增')
          .height(44)
          .onClick(() => this.goCreate())

        Button('设置')
          .height(44)
          .margin({ left: 12 })
          .onClick(() => this.goSettings())
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      if (this.loading) {
        Text('加载中...')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 20 })
      }

      if (!this.loading && this.getDisplayList().length === 0) {
        Text('暂无商品数据')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ top: 40 })
      }

      List() {
        ForEach(this.getDisplayList(), (item: Product) => {
          ListItem() {
            Row() {
              if (this.hasImage(item.imageUri)) {
                Image(item.imageUri)
                  .width(72)
                  .height(72)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover)
              } else {
                Stack() {
                  Text('waiting')
                    .fontSize(12)
                    .fontColor('#666666')
                }
                .width(72)
                .height(72)
                .backgroundColor(this.getPlaceholderColor(item.id))
                .borderRadius(12)
              }

              Column() {
                Text(item.name)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text('分类：' + item.categoryName)
                  .fontSize(13)
                  .fontColor('#666666')
                  .margin({ top: 4 })

                Text('库存：' + item.stockQuantity.toString() + ' ' + item.stockUnit)
                  .fontSize(13)
                  .fontColor('#666666')
                  .margin({ top: 2 })

                Text('成本价：' + item.costPrice.toString())
                  .fontSize(13)
                  .fontColor('#666666')
                  .margin({ top: 2 })
              }
              .layoutWeight(1)
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start)

              Column() {
                Button('编辑')
                  .height(32)
                  .fontSize(13)
                  .onClick(() => {
                    this.goEdit(item.id);
                  })

                Button('删除')
                  .height(32)
                  .fontSize(13)
                  .margin({ top: 8 })
                  .backgroundColor('#ff4d4f')
                  .onClick(async () => {
                    await this.deleteItem(item.id);
                  })
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
          }
          .margin({ left: 16, right: 16, top: 8, bottom: 8 })
        }, (item: Product) => item.id + '_' + item.updatedAt + '_' + this.refreshVersion.toString())
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}