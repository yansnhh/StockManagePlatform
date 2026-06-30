import { CustomField } from '../models/CustomField';
import { DatabaseManager } from './DatabaseManager';
import relationalStore from '@ohos.data.relationalStore';
import { JsonUtil } from '../utils/JsonUtil';

export class CustomFieldRepository {

  private db = DatabaseManager.getStore();

  async insert(data: CustomField): Promise<void> {

    const sql = `
      INSERT INTO custom_field
      (id, field_name, field_type, enum_options, is_enabled, show_in_list, sort_order, remark, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    const args: relationalStore.ValueType[] = [
      data.id,
      data.fieldName,
      data.fieldType,
      JsonUtil.toJson(data.enumOptions),
      data.isEnabled ? 1 : 0,
      data.showInList ? 1 : 0,
      data.sortOrder,
      data.remark,
      data.createdAt,
      data.updatedAt
    ];

    await this.db.executeSql(sql, args);
  }

  async update(data: CustomField): Promise<void> {

    const sql = `
      UPDATE custom_field SET
        field_name = ?,
        field_type = ?,
        enum_options = ?,
        is_enabled = ?,
        show_in_list = ?,
        sort_order = ?,
        remark = ?,
        updated_at = ?
      WHERE id = ?
    `;

    const args: relationalStore.ValueType[] = [
      data.fieldName,
      data.fieldType,
      JsonUtil.toJson(data.enumOptions),
      data.isEnabled ? 1 : 0,
      data.showInList ? 1 : 0,
      data.sortOrder,
      data.remark,
      data.updatedAt,
      data.id
    ];

    await this.db.executeSql(sql, args);
  }

  async delete(id: string): Promise<void> {
    await this.db.executeSql(
      `DELETE FROM custom_field WHERE id = ?`,
      [id]
    );
  }

  async getAll(): Promise<CustomField[]> {

    const result = await this.db.querySql(
      `SELECT * FROM custom_field ORDER BY sort_order ASC`,
      []
    );

    const list: CustomField[] = [];

    if (result.rowCount === 0) {
      return list;
    }

    result.goToFirstRow();

    for (let i = 0; i < result.rowCount; i++) {

      const item = new CustomField();

      item.id = result.getString(0) ?? '';
      item.fieldName = result.getString(1) ?? '';
      item.fieldType = result.getString(2) ?? '';
      item.enumOptions = JsonUtil.fromJson(result.getString(3) ?? '[]');
      item.isEnabled = result.getLong(4) === 1;
      item.showInList = result.getLong(5) === 1;
      item.sortOrder = result.getLong(6) ?? 0;
      item.remark = result.getString(7) ?? '';

      list.push(item);

      result.goToNextRow();
    }

    return list;
  }
}