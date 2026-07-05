export class Product {
  id: string = '';
  name: string = '';
  imageUri: string = '';

  categoryId: string = '';
  categoryName: string = '';

  purchasePlatform: string = '';
  shopName: string = '';
  productLink: string = '';
  orderNo: string = '';
  purchaseDate: string = '';

  stockQuantity: number = 0;
  stockUnit: string = '';
  hasStockQuantity: boolean = false;

  isAccurateStock: boolean = true;

  costPrice: number = 0;
  recommendedPrice: number = 0;
  totalPrice: number = 0;

  canRestock: boolean = false;

  remark: string = '';

  createdAt: string = '';
  updatedAt: string = '';
}

export class ProductForm {
  name: string = '';
  imageUri: string = '';

  categoryId: string = '';
  categoryName: string = '';

  purchasePlatform: string = '';
  shopName: string = '';
  productLink: string = '';
  orderNo: string = '';
  purchaseDate: string = '';

  stockQuantityText: string = '';
  stockUnit: string = '';

  isAccurateStock: boolean = true;

  costPriceText: string = '';

  canRestock: boolean = false;

  remark: string = '';
}