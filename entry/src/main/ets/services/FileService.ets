/**
 * 文件服务占位。
 *
 * 真实接入时建议：
 * 1. 通过系统 Picker 选择 Excel 文件。
 * 2. 保存 Excel 文件时由用户选择保存位置。
 * 3. 如需长期访问用户选择的文件，需要处理临时权限持久化。
 */
export class FileService {
  async pickExcelFile(): Promise<string | undefined> {
    // TODO: 接入系统文件 Picker。
    return undefined;
  }

  async readFile(uri: string): Promise<ArrayBuffer> {
    // TODO: 根据 URI 读取文件内容。
    throw new Error('readFile 尚未接入');
  }

  async saveExcelFile(fileName: string, data: ArrayBuffer): Promise<string> {
    // TODO: 调用系统文件保存能力。
    throw new Error('saveExcelFile 尚未接入');
  }
}
