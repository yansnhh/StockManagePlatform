import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Product } from '../models/Product';
import { CategoryUnit } from '../models/CategoryUnit';
import { ProductService } from '../services/ProductService';
import { CategoryUnitService } from '../services/CategoryUnitService';
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

  async aboutToAppear(): Promise<void> {
    await this.loadCategories();
  }

  async loadCategories(): Promise<void> {
    try {
      this.categories = await this.categoryService.getAll();

      if (this.categories.length > 0) {
        this.applyCategory(this.categories[0]);
      }
    } catch (e) {
      promptAction.showToast({ message: '加载分类失败' });
      console.error('load categories failed:', e);
    }
  }

  applyCategory(category: CategoryUnit): void {
    this.categoryId = category.id;
    this.categoryName = category.categoryName;
    this.units = category.unitOptions;
    this.stockUnit = category.defaultUnit || (category.unitOptions.length > 0 ? category.unitOptions[0] : '');
  }
  getRecommendedPrice(costPrice: number): number {
    if (costPrice <= 0) {
      return 0;
    }

    return Number((costPrice * 1.3).toFixed(2));
  }

  onCategoryChange(selectedName: string): void {
    const category: CategoryUnit | undefined =
      this.categories.find((item: CategoryUnit): boolean => item.categoryName === selectedName);

    if (category !== undefined) {
      this.applyCategory(category);
    }
  }


  private buildProduct(): Product {
    const product: Product = new Product();

    product.name = this.name.trim();
    product.imageUri = this.imageUri;
    product.categoryId = this.categoryId;
    product.categoryName = this.categoryName;
    product.purchasePlatform = this.purchasePlatform.trim();
    product.shopName = this.shopName.trim();
    product.productLink = this.productLink.trim();
    product.orderNo = this.orderNo.trim();
    product.purchaseDate = this.purchaseDate.trim();
    product.stockQuantity = Number(this.stockText || '0');
    product.stockUnit = this.stockUnit;
    product.hasStockQuantity = this.stockText.trim().length > 0;
    product.isAccurateStock = this.isAccurateStockText === '是';
    product.costPrice = Number(this.costPriceText || '0');
    product.recommendedPrice = this.getRecommendedPrice(product.costPrice);
    product.canRestock = this.canRestockText === '是';
    product.remark = this.remark.trim();

    return product;
  }

  async save(): Promise<void> {
    try {
      const product: Product = this.buildProduct();

      await this.productService.insert(product);

      promptAction.showToast({ message: '保存成功' });
      router.back();
    } catch (error) {
      promptAction.showToast({ message: `${error}` });
      console.error('save product failed:', error);
    }
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .height(36)
          .onClick(() => router.back())

        Text('新增商品')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)

        Button('保存')
          .height(36)
          .onClick(async () => {
            await this.save();
          })
      }
      .padding(16)
      .width('100%')

      Scroll() {
        Column({ space: 14 }) {
          ImagePickerBox({
            imageUri: $imageUri,
            onPickImage: () => {
              try {
                promptAction.showToast({ message: '图片选择待接入' });
              } catch (e) {
                console.error('show pick image toast failed:', e);
              }
            },
            onTakePhoto: () => {
              try {
                promptAction.showToast({ message: '拍照待接入' });
              } catch (e) {
                console.error('show take photo toast failed:', e);
              }
            }
          })

          TextInput({ placeholder: '商品名称（必填）', text: this.name })
            .onChange((value: string) => {
              this.name = value;
            })

          Column() {
            Text('商品分类')
              .fontSize(14)
              .fontColor('#666666')
              .width('100%')

            Flex({ wrap: FlexWrap.Wrap }) {
              ForEach(this.categories, (item: CategoryUnit) => {
                Text(item.categoryName)
                  .fontSize(14)
                  .padding(8)
                  .margin(4)
                  .backgroundColor(item.id === this.categoryId ? '#e6f4ff' : '#f2f3f5')
                  .borderRadius(6)
                  .onClick(() => {
                    this.applyCategory(item);
                  })
              }, (item: CategoryUnit) => item.id)
            }
          }

          TextInput({ placeholder: '购买平台，例如淘宝、拼多多、1688', text: this.purchasePlatform })
            .onChange((value: string) => {
              this.purchasePlatform = value;
            })

          TextInput({ placeholder: '店铺名称', text: this.shopName })
            .onChange((value: string) => {
              this.shopName = value;
            })

          TextInput({ placeholder: '商品链接', text: this.productLink })
            .onChange((value: string) => {
              this.productLink = value;
            })

          TextInput({ placeholder: '订单号', text: this.orderNo })
            .onChange((value: string) => {
              this.orderNo = value;
            })

          StockInputWithUnit({
            stockText: $stockText,
            stockUnit: $stockUnit,
            units: this.units
          })

          Row() {
            Text('是否精准库存').layoutWeight(1)
            EnumSelect({ value: $isAccurateStockText, options: ['是', '否'] }).width(120)
          }

          TextInput({ placeholder: '库存单价（必填）', text: this.costPriceText })
            .type(InputType.Number)
            .onChange((value: string) => {
              this.costPriceText = value;
            })

          Text('推荐售价：' + this.getRecommendedPrice(Number(this.costPriceText || '0')).toString())
            .fontSize(16)
            .fontColor('#666666')

          Row() {
            Text('是否可继续进货').layoutWeight(1)
            EnumSelect({ value: $canRestockText, options: ['是', '否'] }).width(120)
          }

          TextArea({ placeholder: '备注', text: this.remark })
            .height(96)
            .onChange((value: string) => {
              this.remark = value;
            })
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