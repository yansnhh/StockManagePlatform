import { CustomField } from '../models/CustomField';
import { CustomFieldRepository } from '../repositories/CustomFieldRepository';

export class CustomFieldService {

  private repository: CustomFieldRepository = new CustomFieldRepository();

  async getAll(): Promise<Array<CustomField>> {
    return await this.repository.listAll();
  }

  async getEnabled(): Promise<Array<CustomField>> {
    const all: Array<CustomField> = await this.repository.listAll();

    const result: Array<CustomField> = new Array<CustomField>();

    for (let i: number = 0; i < all.length; i++) {
      if (all[i].isEnabled) {
        result.push(all[i]);
      }
    }

    return result;
  }

  async create(field: CustomField): Promise<void> {

    this.validate(field);

    if (field.enumOptions === undefined) {
      field.enumOptions = new Array<string>();
    }

    await this.repository.insert(field);
  }

  async update(field: CustomField): Promise<void> {

    this.validate(field);

    const existing: CustomField | undefined =
      await this.repository.listAll()
        .then((list: Array<CustomField>) => {
          for (let i: number = 0; i < list.length; i++) {
            if (list[i].id === field.id) {
              return list[i];
            }
          }
          return undefined;
        });

    if (existing === undefined) {
      throw new Error('CustomField not found');
    }

    await this.repository.update(field);
  }

  async delete(id: string): Promise<void> {
    await this.repository.delete(id);
  }

  private validate(field: CustomField): void {

    if (field.fieldName.trim().length === 0) {
      throw new Error('fieldName is required');
    }

    if (field.fieldType.trim().length === 0) {
      throw new Error('fieldType is required');
    }

    if (
      field.fieldType !== 'TEXT' &&
        field.fieldType !== 'NUMBER' &&
        field.fieldType !== 'ENUM'
    ) {
      throw new Error('invalid fieldType');
    }

    if (field.fieldType === 'ENUM') {
      if (field.enumOptions.length === 0) {
        throw new Error('ENUM must have options');
      }
    }

    if (field.sortOrder < 0) {
      throw new Error('sortOrder must be >= 0');
    }
  }

  validateValue(field: CustomField, value: string): boolean {

    if (field.fieldType === 'TEXT') {
      return true;
    }

    if (field.fieldType === 'NUMBER') {
      const num: number = Number(value);
      return !isNaN(num);
    }

    if (field.fieldType === 'ENUM') {
      for (let i: number = 0; i < field.enumOptions.length; i++) {
        if (field.enumOptions[i] === value) {
          return true;
        }
      }
      return false;
    }

    return false;
  }
}