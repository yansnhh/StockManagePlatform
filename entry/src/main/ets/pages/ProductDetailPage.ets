import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Product } from '../models/Product';
import { ProductService } from '../services/ProductService';
import { NumberUtil } from '../utils/NumberUtil';
import { DateUtil } from '../utils/DateUtil';

@Entry
@Component
struct ProductDetailPage {
  private productService: ProductService = new ProductService();
  @State product?: Product = undefined;

  aboutToAppear() {
    this.loadProduct();
  }

  async loadProduct() {
    const params = router.getParams() as Record<string, string>;
    const id = params?.id;
    if (!id) return;
  }

  async deleteProduct() {
    if (!this.product) return;
    try {
      promptAction.showToast({ message: '删除成功' });
      router.back();
    } catch (error) {
      promptAction.showToast({ message: `${error.message || error}` });
    }
  }

  row(label: string, value: string) {

  }

  build() {
    Column() {
      Row() {
        Button('返回').height(36).onClick(() => router.back())
        Text('商品详情')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)

        if (this.product) {
          Button('编辑')
            .height(36)
            .onClick(() => router.pushUrl({ url: 'pages/ProductEditPage', params: { id: this.product?.id } }))
        }
      }
      .padding(16)
      .width('100%')

      if (!this.product) {
        Text('商品不存在')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 40 })
      } else {
        Scroll() {
          Column() {
            if (this.product.imageUri && this.product.imageUri.length > 0) {
              Image(this.product.imageUri)
                .width('100%')
                .height(220)
                .objectFit(ImageFit.Cover)
                .borderRadius(16)
            }


            Button('删除商品')
              .type(ButtonType.Normal)
              .backgroundColor('#E64545')
              .fontColor(Color.White)
              .margin({ top: 24, bottom: 24 })
              .onClick(() => this.deleteProduct())
          }
          .padding({ left: 16, right: 16, bottom: 24 })
          .width('100%')
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
