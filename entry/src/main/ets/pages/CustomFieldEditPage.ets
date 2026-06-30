import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CustomFieldService } from '../services/CustomFieldService';
import { CustomFieldType } from '../models/CustomField';

@Entry
@Component
struct CustomFieldEditPage {
  private service: CustomFieldService = new CustomFieldService();

  @State fieldName: string = '';
  @State fieldTypeText: string = '文本输入';
  @State enumText: string = '';
  @State isEnabledText: string = '是';
  @State showInListText: string = '否';

  getFieldType(): CustomFieldType {
    if (this.fieldTypeText === '单选枚举') return CustomFieldType.SINGLE_ENUM;
    if (this.fieldTypeText === '多选枚举') return CustomFieldType.MULTI_ENUM;
    return CustomFieldType.TEXT;
  }

  async save() {
    try {
      const type = this.getFieldType();
      const enumOptions = type === CustomFieldType.TEXT
        ? []
        : this.enumText.split(/[、,，]/).map(item => item.trim()).filter(item => item.length > 0);

      await this.service.createField({
        fieldName: this.fieldName.trim(),
        fieldType: type,
        enumOptions,
        isEnabled: this.isEnabledText === '是',
        showInList: this.showInListText === '是',
        sortOrder: 100
      });
      promptAction.showToast({ message: '保存成功' });
      router.back();
    } catch (error) {
      promptAction.showToast({ message: `${error.message || error}` });
    }
  }

  build() {
    Column({ space: 14 }) {
      Row() {
        Button('返回').height(36).onClick(() => router.back())
        Text('新增字段')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)
        Button('保存').height(36).onClick(() => this.save())
      }
      .width('100%')

      TextInput({ placeholder: '字段名称，例如销售状态', text: this.fieldName })
        .onChange((value: string) => this.fieldName = value)

      Select([{ value: '文本输入' }, { value: '单选枚举' }, { value: '多选枚举' }])
        .value(this.fieldTypeText)
        .onSelect((index: number, value?: string) => this.fieldTypeText = value || '文本输入')

      if (this.fieldTypeText !== '文本输入') {
        TextInput({ placeholder: '枚举值，用顿号或逗号分隔，例如 在售、已售、下架', text: this.enumText })
          .onChange((value: string) => this.enumText = value)
      }

      Row() {
        Text('是否启用').layoutWeight(1)
        Select([{ value: '是' }, { value: '否' }])
          .value(this.isEnabledText)
          .onSelect((index: number, value?: string) => this.isEnabledText = value || '是')
          .width(120)
      }

      Row() {
        Text('是否在列表展示').layoutWeight(1)
        Select([{ value: '是' }, { value: '否' }])
          .value(this.showInListText)
          .onSelect((index: number, value?: string) => this.showInListText = value || '否')
          .width(120)
      }
    }
    .padding(16)
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}
