export class DbConvertUtil {

  static toBool(value: number): boolean {
    return value === 1;
  }

  static fromBool(value: boolean): number {
    return value ? 1 : 0;
  }

  static toJson<T>(value: T): string {
    return JSON.stringify(value);
  }

  static fromJson<T>(value: string): T {
    return JSON.parse(value);
  }
}