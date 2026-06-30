export class DateUtil {
  static nowIso(): string {
    let date: Date = new Date();
    return date.toISOString();
  }

  static nowTimestamp(): number {
    let date: Date = new Date();
    return date.getTime();
  }

  static formatDateText(value: string): string {
    if (value.length === 0) {
      return '';
    }
    return value;
  }
}