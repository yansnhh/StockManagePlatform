export class NumberUtil {
  static toNumber(value: string): number {
    let num: number = Number(value);
    if (Number.isNaN(num)) {
      return 0;
    }
    return num;
  }

  static formatPrice(value: number): string {
    return value.toFixed(2);
  }

  static calculateRecommendedPrice(costPrice: number): number {
    return costPrice * 8;
  }
}