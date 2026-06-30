/**
 * 图片服务占位。
 *
 * 真实接入时建议：
 * 1. 通过系统 Photo Picker 选择图片。
 * 2. 通过相机能力拍照。
 * 3. App 仅保存图片 URI，不复制图片文件。
 */
export class ImageService {
  async pickImage(): Promise<string | undefined> {
    // TODO: 接入 HarmonyOS 图片选择 Picker。
    return undefined;
  }

  async takePhoto(): Promise<string | undefined> {
    // TODO: 接入 HarmonyOS 相机能力。
    return undefined;
  }

  async checkImageAvailable(uri?: string): Promise<boolean> {
    return !!uri;
  }
}
