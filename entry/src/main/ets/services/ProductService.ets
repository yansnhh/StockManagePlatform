import { Product } from '../models/Product';
import { ProductRepository } from '../repositories/ProductRepository';

export class ProductService {
  private repo: ProductRepository = new ProductRepository();

  async getAll(): Promise<Product[]> {
    return await this.repo.getAll();
  }

  async getById(id: string): Promise<Product | undefined> {
    return await this.repo.getById(id);
  }

  async insert(data: Product): Promise<void> {
    this.validate(data);

    const now: string = new Date().toISOString();

    data.id = data.id || 'prod_' + Date.now().toString();
    data.createdAt = now;
    data.updatedAt = now;

    await this.repo.insert(data);
  }

  async update(data: Product): Promise<void> {
    this.validate(data);

    if (!data.id) {
      throw new Error('商品ID不能为空');
    }

    data.updatedAt = new Date().toISOString();

    await this.repo.update(data);
  }

  async delete(id: string): Promise<void> {
    await this.repo.delete(id);
  }

  private validate(data: Product): void {
    data.name = data.name.trim();

    if (data.name.length === 0) {
      throw new Error('商品名称不能为空');
    }

    if (!data.categoryId || !data.categoryName) {
      throw new Error('请选择商品分类');
    }

    if (!data.stockUnit) {
      throw new Error('请选择库存单位');
    }

    if (data.stockQuantity < 0) {
      throw new Error('库存数量不能小于0');
    }

    if (data.costPrice <= 0) {
      throw new Error('库存单价必须大于0');
    }
  }
}