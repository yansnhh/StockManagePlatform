import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { CategoryUnit } from '../models/CategoryUnit';
import { CategoryUnitService } from '../services/CategoryUnitService';

@Entry
@Component
struct CategoryUnitEditPage {
  private service: CategoryUnitService = new CategoryUnitService();

  @State model: CategoryUnit = new CategoryUnit();
  @State unitInput: string = '';
  @State categoryId: string = '';

  async aboutToAppear(): Promise<void> {
    const params: Object = router.getParams();
    const temp: Record<string, Object> = params as Record<string, Object>;
    const value: Object | undefined = temp['id'];

    if (value === undefined) {
      promptAction.showToast({ message: '缺少分类ID' });
      return;
    }

    this.categoryId = value as string;

    const data: CategoryUnit | undefined = await this.service.getById(this.categoryId);

    if (data !== undefined) {
      this.model = data;
    }
  }

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
      console.error('update category unit failed:', e);
    }
  }

  build() {
    Column() {
      Text('分类编辑')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      TextInput({
        placeholder: '分类名称',
        text: this.model.categoryName
      })
        .onChange((v: string) => {
          this.model.categoryName = v;
        })

      Row() {
        TextInput({
          placeholder: '新增单位',
          text: this.unitInput
        })
          .layoutWeight(1)
          .onChange((v: string) => {
            this.unitInput = v;
          })

        Button('添加')
          .margin({ left: 8 })
          .onClick(() => {
            this.addUnit();
          })
      }
      .margin({ top: 12 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.model.unitOptions, (unit: string, index: number) => {
          Row() {
            Text(unit)
              .fontSize(14)

            Text(' ×')
              .fontSize(14)
              .fontColor('#ff4d4f')
              .onClick(() => this.removeUnit(index))
          }
          .padding(6)
          .margin(4)
          .backgroundColor(unit === this.model.defaultUnit ? '#e6f4ff' : '#f2f3f5')
          .borderRadius(6)
          .onClick(() => {
            this.model.defaultUnit = unit;
          })
        }, (unit: string) => unit)
      }
      .margin({ top: 12 })

      Text('默认单位：' + (this.model.defaultUnit || '暂无'))
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 12 })

      Row() {
        Text('启用')
          .layoutWeight(1)

        Toggle({ type: ToggleType.Switch, isOn: this.model.isEnabled })
          .onChange((v: boolean) => {
            this.model.isEnabled = v;
          })
      }
      .margin({ top: 16 })

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