export class IdUtil {
  static uuid(prefix: string): string {
    let time: number = new Date().getTime();
    let random: number = Math.floor(Math.random() * 1000000);
    return prefix + '_' + time.toString() + '_' + random.toString();
  }
}