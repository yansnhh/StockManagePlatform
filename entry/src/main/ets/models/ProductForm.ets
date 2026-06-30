import { Product } from '../models/Product';

export class ProductForm {
  id: string = '';
  name: string = '';

  categoryId: string = '';
  categoryName: string = '';

  stockQuantity: number = 0;
  stockUnit: string = '';

  costPrice: number = 0;
  recommendedPrice: number = 0;

  remark: string = '';

  constructor(product?: Product) {
    if (product !== undefined) {
      this.id = product.id;
      this.name = product.name;
      this.categoryId = product.categoryId;
      this.categoryName = product.categoryName;
      this.stockQuantity = product.stockQuantity;
      this.stockUnit = product.stockUnit;
      this.costPrice = product.costPrice;
      this.recommendedPrice = product.recommendedPrice;
      this.remark = product.remark;
    }
  }
}