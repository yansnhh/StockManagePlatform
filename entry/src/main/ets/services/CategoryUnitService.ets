import { CategoryUnitRepository } from '../repositories/CategoryUnitRepository';
import { CategoryUnit } from '../models/CategoryUnit';
import { DbConvertUtil } from '../utils/DbConvertUtil';

export class CategoryUnitService {

  private repo = new CategoryUnitRepository();

  async getAll(): Promise<CategoryUnit[]> {
    return await this.repo.getAll();
  }

  async getById(id: string): Promise<CategoryUnit | undefined> {
    return await this.repo.getById(id);
  }

  async save(data: CategoryUnit): Promise<void> {

    // 🧠 统一业务规则

    if (!data.categoryName || data.categoryName.trim().length === 0) {
      throw new Error('分类名称不能为空');
    }

    if (!data.unitOptions || data.unitOptions.length === 0) {
      throw new Error('至少需要一个单位');
    }

    if (!data.defaultUnit) {
      data.defaultUnit = data.unitOptions[0];
    }

    // 🧠 默认启用逻辑
    data.isEnabled = data.isEnabled ?? true;

    // 🧠 时间统一处理
    const now = new Date().toISOString();
    if (!data.createdAt) {
      data.createdAt = now;
    }
    data.updatedAt = now;

    if (!data.id) {
      data.id = 'cat_' + Date.now();
      await this.repo.insert(data);
    } else {
      await this.repo.update(data);
    }
  }

  async delete(id: string): Promise<void> {
    await this.repo.delete(id);
  }
}