import router from '@ohos.router';
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

    if (value !== undefined) {
      this.categoryId = value as string;

      const data: CategoryUnit | undefined =
        await this.service.getById(this.categoryId);

      if (data !== undefined) {
        this.model = data;
      }
    }
  }

  addUnit(): void {
    if (this.unitInput.trim().length === 0) {
      return;
    }

    this.model.unitOptions.push(this.unitInput);
    this.unitInput = '';
  }

  async save(): Promise<void> {
    await this.service.save(this.model);
    router.back();
  }

  build() {
    Column() {

      Text('分类编辑')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      TextInput({ placeholder: '分类名称' })
        .onChange((v: string) => {
          this.model.categoryName = v;
        })

      Row() {
        TextInput({ placeholder: '新增单位' })
          .width('70%')
          .onChange((v: string) => {
            this.unitInput = v;
          })

        Button('添加')
          .onClick(() => {
            this.addUnit();
          })
      }

      ForEach(this.model.unitOptions, (unit: string) => {
        Row() {
          Text(unit)
        }
      }, (unit: string) => unit)

      TextInput({ placeholder: '默认单位' })
        .onChange((v: string) => {
          this.model.defaultUnit = v;
        })

      Row() {
        Text('启用')

        Toggle({ type: ToggleType.Switch, isOn: this.model.isEnabled })
          .onChange((v: boolean) => {
            this.model.isEnabled = v;
          })
      }

      Button('保存')
        .onClick(async () => {
          await this.save();
        })
    }
    .padding(16)
    .width('100%')
  }
}