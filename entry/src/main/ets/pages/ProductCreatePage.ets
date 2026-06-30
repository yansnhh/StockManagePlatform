import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { ProductForm } from '../models/Product';
import { CategoryUnit } from '../models/CategoryUnit';
import { ProductService } from '../services/ProductService';
import { CategoryUnitService } from '../services/CategoryUnitService';
import { PriceService } from '../services/PriceService';
import { NumberUtil } from '../utils/NumberUtil';
import { StockInputWithUnit } from '../components/StockInputWithUnit';
import { EnumSelect } from '../components/EnumSelect';
import { ImagePickerBox } from '../components/ImagePickerBox';

@Entry
@Component
struct ProductCreatePage {
  private productService: ProductService = new ProductService();
  private categoryService: CategoryUnitService = new CategoryUnitService();

  @State categories: CategoryUnit[] = [];
  @State imageUri: string = '';
  @State name: string = '';
  @State categoryId: string = '';
  @State categoryName: string = '';
  @State units: string[] = [];
  @State stockText: string = '';
  @State stockUnit: string = '';
  @State purchasePlatform: string = '';
  @State shopName: string = '';
  @State productLink: string = '';
  @State orderNo: string = '';
  @State purchaseDate: string = '';
  @State isAccurateStockText: string = '是';
  @State costPriceText: string = '';
  @State canRestockText: string = '否';
  @State remark: string = '';

  aboutToAppear() {
    this.loadCategories();
  }

  async loadCategories() {
    this.categories = await this.categoryService.getAll();
  }

  onCategoryChange(selectedName: string) {
    const category = this.categories.find(item => item.categoryName === selectedName);
    if (!category) {
      return;
    }
    this.categoryId = category.id;
    this.categoryName = category.categoryName;
    this.units = category.unitOptions;
    this.stockUnit = category.defaultUnit || (category.unitOptions.length === 1 ? category.unitOptions[0] : '');
  }





  async save() {
    try {
      promptAction.showToast({ message: '保存成功' });
      router.back();
    } catch (error) {
      promptAction.showToast({ message: `${error.message || error}` });
    }
  }

  build() {
    Column() {
      Row() {
        Button('返回').height(36).onClick(() => router.back())
        Text('新增商品')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)
        Button('保存').height(36).onClick(() => this.save())
      }
      .padding(16)
      .width('100%')

      Scroll() {
        Column({ space: 14 }) {
          ImagePickerBox({
            imageUri: $imageUri,
            onPickImage: () => promptAction.showToast({ message: '图片选择待接入' }),
            onTakePhoto: () => promptAction.showToast({ message: '拍照待接入' })
          })

          TextInput({ placeholder: '商品名称（必填）', text: this.name })
            .onChange((value: string) => this.name = value)



          TextInput({ placeholder: '购买平台，例如淘宝、拼多多、1688', text: this.purchasePlatform })
            .onChange((value: string) => this.purchasePlatform = value)

          TextInput({ placeholder: '店铺名称', text: this.shopName })
            .onChange((value: string) => this.shopName = value)

          TextInput({ placeholder: '商品链接', text: this.productLink })
            .onChange((value: string) => this.productLink = value)

          TextInput({ placeholder: '订单号', text: this.orderNo })
            .onChange((value: string) => this.orderNo = value)

          StockInputWithUnit({ stockText: $stockText, stockUnit: $stockUnit, units: this.units })

          Row() {
            Text('是否精准库存').layoutWeight(1)
            EnumSelect({ value: $isAccurateStockText, options: ['是', '否'] }).width(120)
          }

          TextInput({ placeholder: '库存单价（必填）', text: this.costPriceText })
            .type(InputType.Number)
            .onChange((value: string) => this.costPriceText = value)

          Row() {
            Text('推荐售价')
              .fontSize(16)
              .layoutWeight(1)

          }

          Row() {
            Text('是否可继续进货').layoutWeight(1)
            EnumSelect({ value: $canRestockText, options: ['是', '否'] }).width(120)
          }

          TextArea({ placeholder: '备注', text: this.remark })
            .height(96)
            .onChange((value: string) => this.remark = value)
        }
        .padding({ left: 16, right: 16, bottom: 24 })
        .width('100%')
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
