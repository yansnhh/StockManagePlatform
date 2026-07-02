import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CategoryUnit } from '../models/CategoryUnit';
import { CategoryUnitService } from '../services/CategoryUnitService';

@Entry
@Component
struct CategoryUnitCreatePage {
  private service: CategoryUnitService = new CategoryUnitService();

  @State model: CategoryUnit = new CategoryUnit();
  @State unitInput: string = '';

  addUnit(): void {
    const value: string = this.unitInput.trim();

    if (value.length === 0) {
      return;
    }

    if (this.model.unitOptions.indexOf(value) !== -1) {
      promptAction.showToast({ message: '单位已存在' });
      return;
    }

    this.model.unitOptions = [...this.model.unitOptions, value];

    if (!this.model.defaultUnit) {
      this.model.defaultUnit = value;
    }

    this.unitInput = '';
  }

  removeUnit(index: number): void {
    const list: string[] = [...this.model.unitOptions];
    const removed: string[] = list.splice(index, 1);

    this.model.unitOptions = list;

    if (removed.length > 0 && removed[0] === this.model.defaultUnit) {
      this.model.defaultUnit = list.length > 0 ? list[0] : '';
    }
  }

  async save(): Promise<void> {
    try {
      await this.service.save(this.model);
      promptAction.showToast({ message: '保存成功' });
      router.back();
    } catch (e) {
      promptAction.showToast({ message: `${e}` });
      console.error('save category unit failed:', e);
    }
  }

  build() {
    Column() {
      Text('新增分类')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      TextInput({
        placeholder: '分类名称',
        text: this.model.categoryName
      })
        .onChange((value: string) => {
          this.model.categoryName = value;
        })

      Row() {
        TextInput({
          placeholder: '单位，例如：个、箱、瓶',
          text: this.unitInput
        })
          .layoutWeight(1)
          .onChange((value: string) => {
            this.unitInput = value;
          })

        Button('添加')
          .margin({ left: 8 })
          .onClick(() => this.addUnit())
      }
      .margin({ top: 12 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.model.unitOptions, (item: string, index: number) => {
          Row() {
            Text(item)
              .fontSize(14)

            Text(' ×')
              .fontSize(14)
              .fontColor('#ff4d4f')
              .onClick(() => this.removeUnit(index))
          }
          .padding(6)
          .margin(4)
          .backgroundColor('#f2f3f5')
          .borderRadius(6)
        }, (item: string) => item)
      }
      .margin({ top: 12 })

      Text('默认单位：' + (this.model.defaultUnit || '暂无'))
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 12 })

      Button('保存')
        .width('100%')
        .margin({ top: 24 })
        .onClick(async () => {
          await this.save();
        })
    }
    .padding(16)
    .width('100%')
    .height('100%')
  }
}