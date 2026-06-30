class SelectOptionItem {
  value: string = '';

  constructor(value: string) {
    this.value = value;
  }
}

@Component
export struct EnumSelect {
  @Link value: string;
  @Prop options: string[] = [];

  private buildOptions(): SelectOptionItem[] {
    let result: SelectOptionItem[] = [];
    for (let i: number = 0; i < this.options.length; i++) {
      result.push(new SelectOptionItem(this.options[i]));
    }
    return result;
  }

  build() {
    Select(this.buildOptions())
      .value(this.value)
      .onSelect((index: number, selected?: string) => {
        if (selected) {
          this.value = selected;
        } else {
          this.value = '';
        }
      })
      .width('100%')
  }
}