import { CategoryUnit } from '../models/CategoryUnit';
import { DatabaseManager } from './DatabaseManager';
import relationalStore from '@ohos.data.relationalStore';
import { JsonUtil } from '../utils/JsonUtil';

export class CategoryUnitRepository {

  private db = DatabaseManager.getStore();

  async insert(data: CategoryUnit): Promise<void> {

    const sql = `
      INSERT INTO category_unit
      (id, category_name, unit_options, default_unit, is_enabled, sort_order, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const args: relationalStore.ValueType[] = [
      data.id,
      data.categoryName,
      JsonUtil.toJson(data.unitOptions),     // string[]
      data.defaultUnit,
      data.isEnabled ? 1 : 0,                // boolean → number
      data.sortOrder,
      data.createdAt,
      data.updatedAt
    ];

    await this.db.executeSql(sql, args);
  }

  async update(data: CategoryUnit): Promise<void> {

    const sql = `
      UPDATE category_unit SET
        category_name = ?,
        unit_options = ?,
        default_unit = ?,
        is_enabled = ?,
        sort_order = ?,
        updated_at = ?
      WHERE id = ?
    `;

    const args: relationalStore.ValueType[] = [
      data.categoryName,
      JsonUtil.toJson(data.unitOptions),
      data.defaultUnit,
      data.isEnabled ? 1 : 0,
      data.sortOrder,
      data.updatedAt,
      data.id
    ];

    await this.db.executeSql(sql, args);
  }

  async delete(id: string): Promise<void> {
    await this.db.executeSql(
      `DELETE FROM category_unit WHERE id = ?`,
      [id]
    );
  }

  async getById(id: string): Promise<CategoryUnit | undefined> {

    const result = await this.db.querySql(
      `SELECT * FROM category_unit WHERE id = ?`,
      [id]
    );

    if (result.rowCount === 0) {
      return undefined;
    }

    result.goToFirstRow();

    const item = new CategoryUnit();

    item.id = result.getString(0) ?? '';
    item.categoryName = result.getString(1) ?? '';
    item.unitOptions = JsonUtil.fromJson(result.getString(2) ?? '[]');
    item.defaultUnit = result.getString(3) ?? '';
    item.isEnabled = result.getLong(4) === 1;
    item.sortOrder = result.getLong(5) ?? 0;

    return item;
  }

  async getAll(): Promise<CategoryUnit[]> {

    const result = await this.db.querySql(
      `SELECT * FROM category_unit ORDER BY sort_order ASC`,
      []
    );

    const list: CategoryUnit[] = [];

    if (result.rowCount === 0) {
      return list;
    }

    result.goToFirstRow();

    for (let i = 0; i < result.rowCount; i++) {

      const item = new CategoryUnit();

      item.id = result.getString(0) ?? '';
      item.categoryName = result.getString(1) ?? '';
      item.unitOptions = JsonUtil.fromJson(result.getString(2) ?? '[]');
      item.defaultUnit = result.getString(3) ?? '';
      item.isEnabled = result.getLong(4) === 1;
      item.sortOrder = result.getLong(5) ?? 0;

      list.push(item);

      result.goToNextRow();
    }

    return list;
  }
}