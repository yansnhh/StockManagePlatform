import router from '@ohos.router';
import { CategoryUnit } from '../models/CategoryUnit';
import { CategoryUnitService } from '../services/CategoryUnitService';

@Entry
@Component
struct CategoryUnitCreatePage {

  private service = new CategoryUnitService();

  @State model: CategoryUnit = new CategoryUnit();

  @State unitInput: string = '';

  // =========================
  // 添加单位
  // =========================
  addUnit(): void {

    const value = this.unitInput?.trim();

    if (!value) return;

    if (!this.model.unitOptions) {
      this.model.unitOptions = [];
    }

    if (this.model.unitOptions.includes(value)) return;

    this.model.unitOptions = [...this.model.unitOptions, value];

    // 默认单位自动补
    if (!this.model.defaultUnit) {
      this.model.defaultUnit = value;
    }

    this.unitInput = '';
  }

  // =========================
  // 删除单位
  // =========================
  removeUnit(index: number): void {

    const list = [...this.model.unitOptions];

    const removed = list.splice(index, 1);

    this.model.unitOptions = list;

    // 如果删掉的是默认单位 → 重置
    if (removed[0] === this.model.defaultUnit) {
      this.model.defaultUnit = list[0] ?? '';
    }
  }

  // =========================
  // 保存
  // =========================
  async save(): Promise<void> {

    try {

      if (!this.model.categoryName?.trim()) {
        throw new Error('分类名称不能为空');
      }

      if (!this.model.unitOptions || this.model.unitOptions.length === 0) {
        throw new Error('至少添加一个单位');
      }

      if (!this.model.defaultUnit) {
        this.model.defaultUnit = this.model.unitOptions[0];
      }

      await this.service.save(this.model);

      router.back();

    } catch (e) {
      console.error('save failed:', e);
    }
  }

  build() {

    Column() {

      Text('新增分类')
        .fontSize(20)
        .margin({ bottom: 20 })

      // ================= 分类名称 =================
      TextInput({ placeholder: '分类名称' })
        .onChange((value: string) => {
          this.model.categoryName = value;
        })

      // ================= 单位输入 =================
      Row() {

        TextInput({ placeholder: '单位' })
          .onChange((value: string) => {
            this.unitInput = value;
          })
          .layoutWeight(1)

        Button('添加')
          .onClick(() => this.addUnit())
      }

      // ================= unit tags =================
      Flex({ wrap: FlexWrap.Wrap }) {

        ForEach(this.model.unitOptions, (item: string, index: number) => {

          Row() {

            Text(item)

            Text('×')
              .onClick(() => this.removeUnit(index))
          }
          .padding(6)
          .margin(4)
        })
      }

      // ================= 默认单位 =================
      Text('默认单位：' + this.model.defaultUnit)

      // ================= 保存 =================
      Button('保存')
        .onClick(() => this.save())
    }
    .padding(16)
  }
}