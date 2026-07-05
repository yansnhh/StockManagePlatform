import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Product } from '../models/Product';
import { CategoryUnit } from '../models/CategoryUnit';
import { ProductService } from '../services/ProductService';
import { CategoryUnitService } from '../services/CategoryUnitService';
import { ImagePickerBox } from '../components/ImagePickerBox';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

@Entry
@Component
struct ProductCreatePage {
  private productService: ProductService = new ProductService();
  private categoryService: CategoryUnitService = new CategoryUnitService();

  @State imageUri: string = '';
  @State name: string = '';
  @State categories: CategoryUnit[] = [];
  @State categoryId: string = '';
  @State categoryName: string = '';
  @State purchasePlatform: string = '';
  @State shopName: string = '';
  @State units: string[] = [];
  @State stockText: string = '';
  @State stockUnit: string = '';
  @State unitPriceText: string = '';
  @State remark: string = '';

  async aboutToAppear(): Promise<void> {
    await this.loadCategories();
  }

  showToast(message: string): void {
    try {
      promptAction.showToast({ message });
    } catch (e) {
      console.error('showToast failed:', e);
    }
  }

  goBack(): void {
    try {
      router.back();
    } catch (e) {
      console.error('router back failed:', e);
    }
  }

  async loadCategories(): Promise<void> {
    try {
      this.categories = await this.categoryService.getAll();

      if (this.categories.length > 0) {
        this.applyCategory(this.categories[0]);
      }
    } catch (e) {
      this.showToast('加载分类失败');
      console.error('load categories failed:', e);
    }
  }

  applyCategory(category: CategoryUnit): void {
    this.categoryId = category.id;
    this.categoryName = category.categoryName;
    this.units = [...category.unitOptions];
    this.stockUnit = category.defaultUnit || (category.unitOptions.length > 0 ? category.unitOptions[0] : '');
  }

  getCategoryOptions(): SelectOption[] {
    const options: SelectOption[] = [];

    for (let i = 0; i < this.categories.length; i++) {
      options.push({ value: this.categories[i].categoryName });
    }

    return options;
  }

  getCategorySelectedIndex(): number {
    for (let i = 0; i < this.categories.length; i++) {
      if (this.categories[i].id === this.categoryId) {
        return i;
      }
    }

    return 0;
  }

  getUnitOptions(): SelectOption[] {
    const options: SelectOption[] = [];

    for (let i = 0; i < this.units.length; i++) {
      options.push({ value: this.units[i] });
    }

    return options;
  }

  getUnitSelectedIndex(): number {
    for (let i = 0; i < this.units.length; i++) {
      if (this.units[i] === this.stockUnit) {
        return i;
      }
    }

    return 0;
  }

  getTotalPrice(costPrice: number, stock: number): number {
    if (costPrice <= 0 || stock <= 0) {
      return 0;
    }

    return costPrice * stock;
  }

  getRecommendedPrice(costPrice: number): number {
    if (costPrice <= 0) {
      return 0;
    }

    return Number((costPrice * 5).toFixed(2));
  }

  buildProduct(): Product {
    const product: Product = new Product();

    product.name = this.name.trim();
    product.imageUri = this.imageUri;
    product.categoryId = this.categoryId;
    product.categoryName = this.categoryName;
    product.purchasePlatform = this.purchasePlatform;
    product.shopName = this.shopName;
    product.stockQuantity = Number(this.stockText || '0');
    product.stockUnit = this.stockUnit;
    product.hasStockQuantity = this.stockText.trim().length > 0;
    product.costPrice = Number(this.unitPriceText || '0');
    product.recommendedPrice = this.getRecommendedPrice(product.costPrice);
    product.remark = this.remark.trim();

    return product;
  }

  async save(): Promise<void> {
    try {
      const product: Product = this.buildProduct();

      await this.productService.insert(product);

      this.showToast('保存成功');
      this.goBack();
    } catch (e) {
      this.showToast(`${e}`);
      console.error('save product failed:', e);
    }
  }

  async pickImage(): Promise<void> {
    try {
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;

      const photoPicker = new photoAccessHelper.PhotoViewPicker();
      const result = await photoPicker.select(photoSelectOptions);

      if (result.photoUris.length > 0) {
        this.imageUri = result.photoUris[0];
        console.info('[ProductCreate] pick image uri=' + this.imageUri);
      }
    } catch (e) {
      this.showToast('选择图片失败');
      console.error('[ProductCreate] pick image failed:', e);
    }
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .height(36)
          .onClick(() => this.goBack())

        Text('新增商品')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)
      }
      .height(52)
      .width('100%')
      .padding({ left: 16, right: 16, top: 6, bottom: 6 })

      Scroll() {
        Column({ space: 12 }) {
          Column() {
            Text('商品图片')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            ImagePickerBox({
              imageUri: $imageUri,
              onPickImage: async () => {
                await this.pickImage();
              }
            })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('商品名称 *')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入商品名称', text: this.name })
              .height(48)
              .onChange((value: string) => {
                this.name = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('商品分类 *')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            if (this.categories.length === 0) {
              Text('暂无分类，请先创建分类')
                .fontSize(14)
                .fontColor('#999999')
                .padding(12)
            } else {
              Select(this.getCategoryOptions())
                .selected(this.getCategorySelectedIndex())
                .value(this.categoryName)
                .width('100%')
                .height(48)
                .onSelect((index: number) => {
                  if (index >= 0 && index < this.categories.length) {
                    this.applyCategory(this.categories[index]);
                  }
                })
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('库存数量')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            Row() {
              TextInput({ placeholder: '请输入库存数量', text: this.stockText })
                .height(48)
                .layoutWeight(1)
                .type(InputType.Number)
                .onChange((value: string) => {
                  this.stockText = value;
                })

              if (this.units.length > 0) {
                Select(this.getUnitOptions())
                  .selected(this.getUnitSelectedIndex())
                  .value(this.stockUnit)
                  .width(120)
                  .height(48)
                  .margin({ left: 10 })
                  .onSelect((index: number) => {
                    if (index >= 0 && index < this.units.length) {
                      this.stockUnit = this.units[index];
                    }
                  })
              }
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('成本单价 *')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入成本单价', text: this.unitPriceText })
              .height(48)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.unitPriceText = value;
              })

            Text('建议单价：' + this.getRecommendedPrice(Number(this.unitPriceText || '0')).toString())
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 8 })

            Text('成本总价：' + this.getTotalPrice(Number(this.unitPriceText || '0'),Number(this.unitPriceText || '0')))
              .fontSize(14)
              .fontColor('#666666')
              .margin({ top: 8 })

          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('备注')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextArea({ placeholder: '请输入备注', text: this.remark })
              .height(90)
              .onChange((value: string) => {
                this.remark = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('购入平台')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextArea({ placeholder: '请输入购入来源', text: this.purchasePlatform })
              .height(90)
              .onChange((value: string) => {
                this.purchasePlatform = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('店铺名称')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextArea({ placeholder: '请输入店铺名称', text: this.shopName })
              .height(90)
              .onChange((value: string) => {
                this.shopName = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

        }
        .padding({ left: 16, right: 16, top: 8, bottom: 16 })
      }
      .layoutWeight(1)

      Button('保存')
        .width('92%')
        .height(52)
        .fontSize(18)
        .margin({ bottom: 20 })
        .onClick(async () => {
          await this.save();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}