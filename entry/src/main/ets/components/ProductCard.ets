import { Product } from '../models/Product';
import { NumberUtil } from '../utils/NumberUtil';


@Component
export struct ProductCard {
  @Prop product: Product;
  onTap?: () => void;


  build() {
    Row() {
      Column() {
        if (this.product.imageUri && this.product.imageUri.length > 0) {
          Image(this.product.imageUri)
            .width(56)
            .height(56)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
        } else {
          Text('图')
            .fontSize(14)
            .fontColor('#999999')
            .width(56)
            .height(56)
            .textAlign(TextAlign.Center)
            .backgroundColor('#F2F3F5')
            .borderRadius(8)
        }
      }

      Column() {
        Text(this.product.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(`分类：${this.product.categoryName}`)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 4 })

        Row() {
        }
        .margin({ top: 4 })

        if (this.product.purchasePlatform || this.product.shopName) {
          Text(`来源：${this.product.purchasePlatform || ''}${this.product.shopName ? ' / ' + this.product.shopName : ''}`)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
        }
      }
      .margin({ left: 12 })
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .onClick(() => {
      if (this.onTap) {
        this.onTap();
      }
    })
  }
}
