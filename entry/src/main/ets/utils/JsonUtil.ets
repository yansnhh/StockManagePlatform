export class JsonUtil {

  static toJson(data: string[]): string {
    return JSON.stringify(data);
  }

  static fromJson(data: string): string[] {
    if (!data) {
      return [];
    }

    return JSON.parse(data) as string[];
  }
}