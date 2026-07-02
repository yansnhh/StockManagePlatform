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

  showToast(message: string): void {
    try {
      promptAction.showToast({ message });
    } catch (e) {
      console.error('showToast failed:', e);
    }
  }

  goBack(): void {
    try {
      router.back();
    } catch (e) {
      console.error('router.back failed:', e);
    }
  }

  addUnit(): void {
    const value: string = this.unitInput.trim();

    if (value.length === 0) {
      this.showToast('请输入单位名称');
      return;
    }

    if (this.model.unitOptions.indexOf(value) !== -1) {
      this.showToast('单位已存在');
      return;
    }

    this.model.unitOptions = [...this.model.unitOptions, value];

    if (!this.model.defaultUnit) {
      this.model.defaultUnit = value;
    }

    this.unitInput = '';
  }

  removeUnit(unit: string): void {
    const list: string[] = this.model.unitOptions.filter((item: string): boolean => item !== unit);
    this.model.unitOptions = list;

    if (this.model.defaultUnit === unit) {
      this.model.defaultUnit = list.length > 0 ? list[0] : '';
    }
  }

  setDefaultUnit(unit: string): void {
    this.model.defaultUnit = unit;
  }

  async save(): Promise<void> {
    try {
      await this.service.save(this.model);
      this.showToast('保存成功');
      this.goBack();
    } catch (e) {
      this.showToast(`${e}`);
      console.error('save category failed:', e);
    }
  }

  build() {
    Column() {
      Row() {
        Button('返回')
          .height(34)
          .onClick(() => {
            router.back();
          })

        Text('新增分类')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .layoutWeight(1)
      }
      .height(48)
      .width('100%')
      .padding({
        left:16,
        right:16,
        top:2,
        bottom:6
      })

      Scroll() {
        Column({ space: 1 }) {
          Column() {
            Text('分类名称')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            TextInput({
              placeholder: '请输入分类名称',
              text: this.model.categoryName
            })
              .height(48)
              .onChange((value: string) => {
                this.model.categoryName = value;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('单位')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            Row() {
              TextInput({
                placeholder: '请输入单位，例如：个、箱、瓶',
                text: this.unitInput
              })
                .height(48)
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.unitInput = value;
                })

              Button('添加')
                .height(48)
                .margin({ left: 10 })
                .onClick(() => this.addUnit())
            }

            Text('已添加单位')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 3, bottom: 8 })

            if (this.model.unitOptions.length === 0) {
              Text('暂无单位，请先添加')
                .fontSize(13)
                .fontColor('#999999')
            } else {
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.model.unitOptions, (unit: string) => {
                  Row() {
                    Text(unit)
                      .fontSize(14)

                    Text(' ×')
                      .fontSize(14)
                      .fontColor('#ff4d4f')
                      .margin({ left: 6 })
                      .onClick(() => {
                        this.removeUnit(unit);
                      })
                  }
                  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
                  .margin({ right: 8, bottom: 8 })
                  .backgroundColor('#F2F3F5')
                  .borderRadius(18)
                }, (unit: string) => unit)
              }
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)

          Column() {
            Text('默认单位')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })

            if (this.model.unitOptions.length === 0) {
              Text('请先添加单位')
                .fontSize(14)
                .fontColor('#999999')
                .padding(12)
            } else {
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(this.model.unitOptions, (unit: string) => {
                  Text(unit === this.model.defaultUnit ? unit + '  ✓' : unit)
                    .fontSize(14)
                    .fontColor(unit === this.model.defaultUnit ? '#0A59F7' : '#333333')
                    .padding({ left: 14, right: 14, top: 8, bottom: 8 })
                    .margin({ right: 8, bottom: 8 })
                    .backgroundColor(unit === this.model.defaultUnit ? '#E6F0FF' : '#F2F3F5')
                    .borderRadius(18)
                    .onClick(() => {
                      this.setDefaultUnit(unit);
                    })
                }, (unit: string) => unit)
              }
            }

            Text('创建商品时会自动选中该默认单位')
              .fontSize(12)
              .fontColor('#888888')
              .margin({ top: 6 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(16)
        }
        .padding({ left: 16, right: 16, top: 3, bottom: 16 })
      }
      .layoutWeight(1)

      Button('保存')
        .width('92%')
        .height(52)
        .fontSize(18)
        .margin({ top: 3 })
        .onClick(async () => {
          await this.save();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F7F8FA')
  }
}