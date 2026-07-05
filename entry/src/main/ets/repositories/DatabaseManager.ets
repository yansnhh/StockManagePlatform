import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';
import { DbConstants } from '../constants/DbConstants';
import { CategoryUnit } from '../models/CategoryUnit'
import { JsonUtil } from '../utils/JsonUtil';

class DefaultCategoryData {
  id: string = '';
  name: string = '';
  unitOptions: string = '';
  defaultUnit: string = '';
  sortOrder: number = 0;

  constructor(
    id: string,
    name: string,
    unitOptions: string,
    defaultUnit: string,
    sortOrder: number
  ) {
    this.id = id;
    this.name = name;
    this.unitOptions = unitOptions;
    this.defaultUnit = defaultUnit;
    this.sortOrder = sortOrder;
  }
}

export class DatabaseManager {
  private static rdbStore: relationalStore.RdbStore | undefined;

  // =========================
  // init
  // =========================
  static async init(context: common.UIAbilityContext): Promise<void> {

    if (DatabaseManager.rdbStore) {
      return;
    }

    const config: relationalStore.StoreConfig = {
      name: DbConstants.DB_NAME,
      securityLevel: relationalStore.SecurityLevel.S1
    };

    DatabaseManager.rdbStore =
      await relationalStore.getRdbStore(context, config);

    await DatabaseManager.createTables();
    await DatabaseManager.insertDefaultCategories();
  }

  // =========================
  // getStore
  // =========================
  static getStore(): relationalStore.RdbStore {

    if (!DatabaseManager.rdbStore) {
      throw new Error('Database not initialized');
    }

    return DatabaseManager.rdbStore;
  }

  // =========================
  // create tables
  // =========================
  private static async createTables(): Promise<void> {

    const db = DatabaseManager.getStore();

    await db.executeSql(`
      CREATE TABLE IF NOT EXISTS product (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        image_uri TEXT,
        category_id TEXT NOT NULL,
        category_name TEXT NOT NULL,
        purchase_platform TEXT,
        shop_name TEXT,
        stock_quantity REAL,
        stock_unit TEXT,
        cost_price REAL,
        recommended_price REAL,
        total_price REAL,
        remark TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    `);

    await db.executeSql(`
      CREATE TABLE IF NOT EXISTS category_unit (
        id TEXT PRIMARY KEY,
        category_name TEXT NOT NULL UNIQUE,
        unit_options TEXT NOT NULL,
        default_unit TEXT,
        is_enabled INTEGER NOT NULL DEFAULT 1,
        sort_order INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    `);

    await db.executeSql(`
      CREATE TABLE IF NOT EXISTS custom_field (
        id TEXT PRIMARY KEY,
        field_name TEXT NOT NULL,
        field_type TEXT NOT NULL,
        enum_options TEXT,
        is_enabled INTEGER NOT NULL DEFAULT 1,
        show_in_list INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER DEFAULT 0,
        remark TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    `);

    await db.executeSql(`
      CREATE TABLE IF NOT EXISTS product_custom_field_value (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        field_id TEXT NOT NULL,
        field_value TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    `);
  }

  // =========================
  // default data
  // =========================
  private static async insertDefaultCategories(): Promise<void> {

    const db = DatabaseManager.getStore();
    const now: string = new Date().toISOString();

    const defaults: DefaultCategoryData[] = [];

    defaults.push(new DefaultCategoryData(
      'cat_1',
      '杯子',
      '["个","箱"]',
      '个',
      1
    ));

    defaults.push(new DefaultCategoryData(
      'cat_2',
      '数据线',
      '["条","包"]',
      '条',
      2
    ));

    defaults.push(new DefaultCategoryData(
      'cat_3',
      '手机支架',
      '["个","箱"]',
      '个',
      3
    ));

    defaults.push(new DefaultCategoryData(
      'cat_4',
      '饰品',
      '["件","盒"]',
      '件',
      4
    ));

    defaults.push(new DefaultCategoryData(
      'cat_5',
      '食品',
      '["g","kg","袋"]',
      '袋',
      5
    ));

    for (let i: number = 0; i < defaults.length; i++) {

      const item: DefaultCategoryData = defaults[i];

      const args: relationalStore.ValueType[] = [
        item.id,
        item.name,
        item.unitOptions,
        item.defaultUnit,
        1,
        item.sortOrder,
        now,
        now
      ];

      await db.executeSql(
        `INSERT OR IGNORE INTO category_unit
        (id, category_name, unit_options, default_unit, is_enabled, sort_order, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
        args
      );
    }
  }
}