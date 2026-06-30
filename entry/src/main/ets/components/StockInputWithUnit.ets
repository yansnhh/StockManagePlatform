class UnitSelectOption {
  value: string = '';

  constructor(value: string) {
    this.value = value;
  }
}

@Component
export struct StockInputWithUnit {
  @Link stockText: string;
  @Link stockUnit: string;
  @Prop units: string[] = [];

  private buildUnitOptions(): UnitSelectOption[] {
    let result: UnitSelectOption[] = [];
    for (let i: number = 0; i < this.units.length; i++) {
      result.push(new UnitSelectOption(this.units[i]));
    }
    return result;
  }

  build() {
    Row() {
      TextInput({ placeholder: '整体库存，可不填', text: this.stockText })
        .type(InputType.Number)
        .onChange((value: string) => {
          this.stockText = value;
        })
        .layoutWeight(1)

      Select(this.buildUnitOptions())
        .value(this.stockUnit)
        .onSelect((index: number, value?: string) => {
          if (value) {
            this.stockUnit = value;
          } else {
            this.stockUnit = '';
          }
        })
        .width(96)
        .margin({ left: 8 })
    }
    .width('100%')
  }
}