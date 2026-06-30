import relationalStore from '@ohos.data.relationalStore';
import { DatabaseManager } from './DatabaseManager';

export class BaseRepository {

  protected db = DatabaseManager.getStore();

  protected async execute(sql: string, args: relationalStore.ValueType[]): Promise<void> {
    await this.db.executeSql(sql, args);
  }

  protected async query(sql: string, args: relationalStore.ValueType[]): Promise<relationalStore.ResultSet> {
    return await this.db.querySql(sql, args);
  }
}