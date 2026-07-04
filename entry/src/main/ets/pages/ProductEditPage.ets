import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Product } from '../models/Product';
import { CategoryUnit } from '../models/CategoryUnit';
import { ProductService } from '../services/ProductService';
import { CategoryUnitService } from '../services/CategoryUnitService';
import { ImagePickerBox } from '../components/ImagePickerBox';

@Entry
@Component
struct ProductEditPage {
  private productService: ProductService = new ProductService();
  private categoryService: CategoryUnitService = new CategoryUnitService();

  @State categories: CategoryUnit[] = [];
  @State productId: string = '';
  @State imageUri: string = '';
  @State name: string = '';
  @State categoryId: string = '';
  @State categoryName: string = '';
  @State units: string[] = [];
  @State stockText: string = '';
  @State stockUnit: string = '';
  @State costPriceText: string = '';
  @State remark: string = '';
  @State createdAt: string = '';
  @State refreshVersion: number = 0;

  async aboutToAppear(): Promise<void> {
    await this.loadPageData();
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

  async loadPageData(): Promise<void> {
    try {
      await this.loadCategories();

      const params: Object = router.getParams();
      console.info('[ProductEdit] params=' + JSON.stringify(params));

      const temp: Record<string, Object> = params as Record<string, Object>;
      const value: Object | undefined = temp['id'];

      if (value === undefined) {
        this.showToast('缺少商品ID');
        return;
      }

      this.productId = value as string;

      const product: Product | undefined = await this.productService.getById(this.productId);
      console.info('[ProductEdit] product=' + JSON.stringify(product));

      if (product === undefined) {
        this.showToast('商品不存在');
        return;
      }

      this.applyProduct(product);
    } catch (e) {
      this.showToast('加载商品失败');
      console.error('[ProductEdit] load product failed:', e);
    }
  }

  async loadCategories(): Promise<void> {
    this.categories = await this.categoryService.getAll();
  }

  applyProduct(product: Product): void {
    this.productId = product.id;
    this.imageUri = product.imageUri;
    this.name = product.name;
    this.categoryId = product.categoryId;
    this.categoryName = product.categoryName;
    this.stockText = product.stockQuantity.toString();
    this.stockUnit = product.stockUnit;
    this.costPriceText = product.costPrice.toString();
    this.remark = product.remark;
    this.createdAt = product.createdAt;

    this.refreshUnitsByCategory();
    this.refreshVersion = this.refreshVersion + 1;
  }

  refreshUnitsByCategory(): void {
    this.units = [];

    for (let i = 0; i < this.categories.length; i++) {
      if (this.categories[i].id === this.categoryId) {
        this.units = [...this.categories[i].unitOptions];

        if (this.stockUnit.length === 0 && this.units.length > 0) {
          this.stockUnit = this.categories[i].defaultUnit || this.units[0];
        }

        return;
      }
    }
  }

  applyCategory(category: CategoryUnit): void {
    this.categoryId = category.id;
    this.categoryName = category.categoryName;
    this.units = [...category.unitOptions];
    this.stockUnit = category.defaultUnit || (category.unitOptions.length > 0 ? category.unitOptions[0] : '');
    this.refreshVersion = this.refreshVersion + 1;
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

  getRecommendedPrice(costPrice: number): number {
    if (costPrice <= 0) {
      return 0;
    }

    return Number((costPrice * 1.3).toFixed(2));
  }

  buildProduct(): Product {
    const product: Product = new Product();

    product.id = this.productId;
    product.name = this.name.trim();
    product.imageUri = this.imageUri;
    product.categoryId = this.categoryId;
    product.categoryName = this.categoryName;
    product.stockQuantity = Number(this.stockText || '0');
    product.stockUnit = this.stockUnit;
    product.hasStockQuantity = this.stockText.trim().length > 0;
    product.costPrice = Number(this.costPriceText || '0');
    product.recommendedPrice = this.getRecommendedPrice(product.costPrice);
    product.remark = this.remark.trim();
    product.createdAt = this.createdAt;

    return product;
  }

  async save(): Promise<void> {
    try {
      const product: Product = this.buildProduct();

      await this.productService.update(product);

      this.showToast('保存成功');
      this.goBack();
    } catch (e) {
      this.showToast(`${e}`);
      console.error('update product failed:', e);
    }
  }

  build() {
    Column() {
      Text(this.refreshVersion.toString())
        .width(0)
        .height(0)
        .opacity(0)

      Row() {
        Button('返回')
          .height(36)
          .onClick(() => this.goBack())

        Text('编辑商品')
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
              onPickImage: () => {
                this.showToast('图片选择待接入');
              },
              onTakePhoto: () => {
                this.showToast('拍照待接入');
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
            Text('成本价 *')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextInput({ placeholder: '请输入成本价', text: this.costPriceText })
              .height(48)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.costPriceText = value;
              })

            Text('建议价：' + this.getRecommendedPrice(Number(this.costPriceText || '0')).toString())
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