import { Product } from '../models/Product';
import { DatabaseManager } from './DatabaseManager';
import relationalStore from '@ohos.data.relationalStore';

export class ProductRepository {

  private db = DatabaseManager.getStore();

  async insert(data: Product): Promise<void> {
    const sql = `
    INSERT INTO product (
      id,
      name,
      image_uri,
      category_id,
      category_name,
      purchase_platform,
      shop_name,
      stock_quantity,
      stock_unit,
      cost_price,
      recommended_price,
      total_price,
      remark,
      created_at,
      updated_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

    const args: relationalStore.ValueType[] = [
      data.id,
      data.name,
      data.imageUri,
      data.categoryId,
      data.categoryName,
      data.purchasePlatform,
      data.shopName,
      data.stockQuantity,
      data.stockUnit,
      data.costPrice,
      data.recommendedPrice,
      data.totalPrice,
      data.remark,
      data.createdAt,
      data.updatedAt
    ];

    await this.db.executeSql(sql, args);
  }

  async update(data: Product): Promise<void> {
    const sql = `
    UPDATE product SET
      name = ?,
      image_uri = ?,
      category_id = ?,
      category_name = ?,
      purchase_platform = ?,
      shop_name = ?,
      stock_quantity = ?,
      stock_unit = ?,
      cost_price = ?,
      recommended_price = ?,
      total_price = ?,
      remark = ?,
      updated_at = ?
    WHERE id = ?
  `;

    const args: relationalStore.ValueType[] = [
      data.name,
      data.imageUri,
      data.categoryId,
      data.categoryName,
      data.purchasePlatform,
      data.shopName,
      data.stockQuantity,
      data.stockUnit,
      data.costPrice,
      data.recommendedPrice,
      data.totalPrice,
      data.remark,
      data.updatedAt,
      data.id
    ];

    await this.db.executeSql(sql, args);
  }

  async delete(id: string): Promise<void> {

    await this.db.executeSql(
      `DELETE FROM product WHERE id = ?`,
      [id]
    );
  }

  async getById(id: string): Promise<Product | undefined> {
    const result = await this.db.querySql(
      `SELECT id, name, image_uri, category_id, category_name,purchase_platform,
      shop_name, stock_quantity, stock_unit, cost_price, recommended_price, total_price,
            remark, created_at, updated_at
     FROM product WHERE id = ?`,
      [id]
    );

    if (result.rowCount === 0) {
      return undefined;
    }

    result.goToFirstRow();

    const item = new Product();
    item.id = result.getString(0) ?? '';
    item.name = result.getString(1) ?? '';
    item.imageUri = result.getString(2) ?? '';
    item.categoryId = result.getString(3) ?? '';
    item.categoryName = result.getString(4) ?? '';
    item.purchasePlatform = result.getString(5) ?? '';
    item.shopName = result.getString(6) ?? '';
    item.stockQuantity = result.getDouble(7) ?? 0;
    item.stockUnit = result.getString(8) ?? '';
    item.costPrice = result.getDouble(9) ?? 0;
    item.totalPrice = result.getDouble(10) ?? 0;
    item.recommendedPrice = result.getDouble(11) ?? 0;
    item.remark = result.getString(12) ?? '';
    item.createdAt = result.getString(13) ?? '';
    item.updatedAt = result.getString(14) ?? '';

    return item;
  }

  async getAll(): Promise<Product[]> {
    const result = await this.db.querySql(
      `SELECT id, name, image_uri, category_id, category_name,purchase_platform,
      shop_name, stock_quantity, stock_unit, cost_price, recommended_price, total_price,
            remark, created_at, updated_at
     FROM product ORDER BY created_at DESC`,
      []
    );

    const list: Product[] = [];

    if (result.rowCount === 0) {
      return list;
    }

    result.goToFirstRow();

    for (let i = 0; i < result.rowCount; i++) {
      const item = new Product();

      item.id = result.getString(0) ?? '';
      item.name = result.getString(1) ?? '';
      item.imageUri = result.getString(2) ?? '';
      item.categoryId = result.getString(3) ?? '';
      item.categoryName = result.getString(4) ?? '';
      item.purchasePlatform = result.getString(5) ?? '';
      item.shopName = result.getString(6) ?? '';
      item.stockQuantity = result.getDouble(7) ?? 0;
      item.stockUnit = result.getString(8) ?? '';
      item.costPrice = result.getDouble(9) ?? 0;
      item.totalPrice = result.getDouble(10) ?? 0;
      item.recommendedPrice = result.getDouble(11) ?? 0;
      item.remark = result.getString(12) ?? '';
      item.createdAt = result.getString(13) ?? '';
      item.updatedAt = result.getString(14) ?? '';

      list.push(item);
      result.goToNextRow();
    }

    return list;
  }

}