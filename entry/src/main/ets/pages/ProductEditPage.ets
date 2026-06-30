import { ProductForm } from '../models/ProductForm';
import { ProductService } from '../services/ProductService';
import { CategoryUnitService } from '../services/CategoryUnitService';
import { CategoryUnit } from '../models/CategoryUnit';
import { Product } from '../models/Product';
@Entry
@Component
struct ProductEditPage {

  private productService: ProductService = new ProductService();
  private categoryService: CategoryUnitService = new CategoryUnitService();

  @State form: ProductForm = new ProductForm();
  @State categoryList: Array<CategoryUnit> = new Array<CategoryUnit>();

  @State unitList: Array<string> = new Array<string>();

  @State isEdit: boolean = false;

  async aboutToAppear(): Promise<void> {
    await this.loadCategories();
  }

  async loadCategories(): Promise<void> {
    this.categoryList = await this.categoryService.getAll();
  }

  async onCategoryChange(categoryId: string): Promise<void> {

    for (let i: number = 0; i < this.categoryList.length; i++) {
      if (this.categoryList[i].id === categoryId) {

        this.form.categoryId = this.categoryList[i].id;
        this.form.categoryName = this.categoryList[i].categoryName;

        this.unitList = this.categoryList[i].unitOptions;

        if (this.unitList.length > 0) {
          this.form.stockUnit = this.unitList[0];
        }

        break;
      }
    }
  }

  async save(): Promise<void> {
    const product: Product = new Product();

    product.id = this.form.id;
    product.name = this.form.name;
    product.categoryId = this.form.categoryId;
    product.categoryName = this.form.categoryName;
    product.stockQuantity = this.form.stockQuantity;
    product.stockUnit = this.form.stockUnit;
    product.costPrice = this.form.costPrice;
    product.recommendedPrice = this.form.recommendedPrice;
    product.remark = this.form.remark;

    product.imageUri = '';
    product.purchasePlatform = '';
    product.shopName = '';
    product.productLink = '';
    product.orderNo = '';
    product.purchaseDate = '';
    product.isAccurateStock = true;
    product.canRestock = true;

    product.createdAt = '';
    product.updatedAt = '';

    if (this.isEdit) {
      await this.productService.update(product);
    } else {
      await this.productService.insert(product);
    }
  }

  build() {
    Column() {

      Text(this.isEdit ? '编辑商品' : '新增商品')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      // 商品名称
      TextInput({ placeholder: '商品名称' })
        .onChange((v: string) => {
          this.form.name = v;
        })

      // 分类选择
      ForEach(this.categoryList, (item: CategoryUnit) => {
        Row() {
          Text(item.categoryName)
        }
        .onClick(() => {
          this.onCategoryChange(item.id);
        })
      }, (item: CategoryUnit) => item.id)

      // 单位选择
      ForEach(this.unitList, (unit: string) => {
        Row() {
          Text(unit)
        }
        .onClick(() => {
          this.form.stockUnit = unit;
        })
      }, (unit: string) => unit)

      // 库存
      TextInput({ placeholder: '库存数量' })
        .type(InputType.Number)
        .onChange((v: string) => {
          this.form.stockQuantity = Number(v);
        })

      // 成本价
      TextInput({ placeholder: '成本价' })
        .type(InputType.Number)
        .onChange((v: string) => {
          this.form.costPrice = Number(v);
        })

      // 建议价
      TextInput({ placeholder: '建议价' })
        .type(InputType.Number)
        .onChange((v: string) => {
          this.form.recommendedPrice = Number(v);
        })

      // 备注
      TextInput({ placeholder: '备注' })
        .onChange((v: string) => {
          this.form.remark = v;
        })

      Button(this.isEdit ? '保存修改' : '新增商品')
        .onClick(async () => {
          await this.save();
        })
    }
    .padding(16)
  }
}