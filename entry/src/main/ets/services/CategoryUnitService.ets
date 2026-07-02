import { CategoryUnitRepository } from '../repositories/CategoryUnitRepository';
import { CategoryUnit } from '../models/CategoryUnit';

export class CategoryUnitService {
  private repo: CategoryUnitRepository = new CategoryUnitRepository();

  async getAll(): Promise<CategoryUnit[]> {
    return await this.repo.getAll();
  }

  async getById(id: string): Promise<CategoryUnit | undefined> {
    return await this.repo.getById(id);
  }

  async save(data: CategoryUnit): Promise<void> {
    data.categoryName = data.categoryName.trim();

    if (data.categoryName.length === 0) {
      throw new Error('分类名称不能为空');
    }

    data.unitOptions = data.unitOptions
      .map((item: string): string => item.trim())
      .filter((item: string): boolean => item.length > 0);

    data.unitOptions = Array.from(new Set(data.unitOptions));

    if (data.unitOptions.length === 0) {
      throw new Error('至少需要一个单位');
    }

    if (!data.defaultUnit || data.unitOptions.indexOf(data.defaultUnit) === -1) {
      data.defaultUnit = data.unitOptions[0];
    }

    data.isEnabled = data.isEnabled ?? true;

    const now: string = new Date().toISOString();

    if (!data.createdAt) {
      data.createdAt = now;
    }

    data.updatedAt = now;

    if (!data.id) {
      data.id = 'cat_' + Date.now().toString();
      await this.repo.insert(data);
    } else {
      await this.repo.update(data);
    }
  }

  async delete(id: string): Promise<void> {
    await this.repo.delete(id);
  }
}