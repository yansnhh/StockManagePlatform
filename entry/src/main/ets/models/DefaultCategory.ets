export class DefaultCategory {
  id: string = '';
  name: string = '';
  unitOptions: string = '';
  defaultUnit: string = '';
  isEnabled: number = 1;
  sortOrder: number = 0;

  constructor(
    id: string,
    name: string,
    unitOptions: string,
    defaultUnit: string,
    sortOrder: number
  ) {
    this.id = id;
    this.name = name;
    this.unitOptions = unitOptions;
    this.defaultUnit = defaultUnit;
    this.sortOrder = sortOrder;
  }
}