import { Product } from '../models/Product';
import { ProductService } from '../services/ProductService';
import router from '@ohos.router';

@Entry
@Component
struct ProductListPage {

  private service = new ProductService();

  @State productList: Product[] = []; // ✅必须在页面
  @State keyword: string = '';
  @State loading: boolean = false;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async loadData(): Promise<void> {
    this.loading = true;

    this.productList = await this.service.getAll();

    this.loading = false;
  }

  build() {
    Column() {

      // 第一行：搜索
      Row() {
        TextInput({ placeholder: '搜索商品' })
          .width('70%')
          .onChange((value: string) => {
            this.keyword = value;
          })

        Button('搜索')
          .margin({ left: 8 })
          .onClick(async () => {
            await this.loadData();
          })
      }
      .width('100%')
      .margin({ bottom: 10 })

      // 第二行：操作按钮
      Row() {
        Button('新增')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ProductEditPage'
            });
          })

        Button('设置')
          .margin({ left: 10 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/SettingsPage'
            });
          })
      }
      .width('100%')
    }    .width('100%')
    .height('100%')
  }
}