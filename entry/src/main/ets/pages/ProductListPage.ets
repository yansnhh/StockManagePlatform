import { Product } from '../models/Product';
import { ProductService } from '../services/ProductService';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';


@Entry
@Component
struct ProductListPage {

  private service = new ProductService();

  @State productList: Product[] = []; // ✅必须在页面
  @State keyword: string = '';
  @State loading: boolean = false;
  @State refreshVersion: number = 0;

  async aboutToAppear(): Promise<void> {
    await this.loadData();
  }

  async onPageShow(): Promise<void> {
    console.info('[ProductList] onPageShow');
    await this.loadData();
  }

  showToast(message: string): void {
    try {
      promptAction.showToast({ message });
    } catch (e) {
      console.error('showToast failed:', e);
    }
  }

  async loadData(): Promise<void> {
    this.loading = true;

    try {
      console.info('[ProductList] loadData start');

      const result: Product[] = await this.service.getAll();

      this.productList = [];
      this.productList = [...result];

      this.refreshVersion = this.refreshVersion + 1;

      console.info('[ProductList] refreshVersion:', this.refreshVersion.toString());
      console.info('[ProductList] list state updated:', JSON.stringify(this.productList));
    } catch (e) {
      this.showToast('加载分类失败');
      console.error('[CategoryUnitList] load failed:', e);
    }

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
              url: 'pages/ProductCreatePage'
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