import { Product } from '../models/Product';
import { ProductRepository } from '../repositories/ProductRepository';

export class ProductService {

  private repo = new ProductRepository();

  // =========================
  // 查询全部
  // =========================
  async getAll(): Promise<Product[]> {
    return await this.repo.getAll();
  }

  // =========================
  // 新增
  // =========================
  async insert(data: Product): Promise<void> {
    await this.repo.insert(data);
  }

  // =========================
  // 更新
  // =========================
  async update(data: Product): Promise<void> {
    await this.repo.update(data);
  }

  // =========================
  // 删除
  // =========================
  async delete(id: string): Promise<void> {
    await this.repo.delete(id);
  }

  // =========================
  // 查询单条
  // =========================
  async getById(id: string): Promise<Product | undefined> {
    return await this.repo.getById(id);
  }
}