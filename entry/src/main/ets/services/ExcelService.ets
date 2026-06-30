import { ImportResult } from '../models/ImportResult';
import { Product } from '../models/Product';
import { DateUtil } from '../utils/DateUtil';

/**
 * Excel 服务占位。
 *
 * 当前代码骨架先定义业务接口。
 * 实际开发时需要选择 ArkTS 可用的 xlsx 库，或先用 CSV 作为过渡方案。
 */
export class ExcelService {
  buildExportFileName(): string {
    return `库存数据_${DateUtil.fileTimestamp()}.xlsx`;
  }

  async exportProductsToExcel(products: Product[]): Promise<ArrayBuffer> {
    // TODO: 使用 xlsx 库生成 Excel。
    // 字段包括：商品名称、商品图片地址、商品分类、库存、单位、是否精准库存、库存单价、推荐售价、是否可继续进货等。
    throw new Error('exportProductsToExcel 尚未接入 Excel 生成库');
  }

  async importProductsFromExcel(fileUri: string): Promise<ImportResult> {
    // TODO: 使用 xlsx 库解析 Excel，并逐行校验后写入数据库。
    return {
      successCount: 0,
      failCount: 0,
      skipCount: 0,
      errors: [{ rowIndex: 0, reason: `Excel 解析尚未接入：${fileUri}` }]
    };
  }
}
