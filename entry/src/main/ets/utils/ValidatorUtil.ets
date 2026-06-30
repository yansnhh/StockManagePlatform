export class ValidateResult {
  ok: boolean = true;
  message: string = '';

  constructor(ok: boolean, message: string) {
    this.ok = ok;
    this.message = message;
  }
}

export class ValidatorUtil {
  static success(): ValidateResult {
    return new ValidateResult(true, '');
  }

  static fail(message: string): ValidateResult {
    return new ValidateResult(false, message);
  }

  static isEmpty(value: string): boolean {
    return value.trim().length === 0;
  }

  static isPositiveNumberText(value: string): boolean {
    if (value.trim().length === 0) {
      return false;
    }

    let num: number = Number(value);
    if (Number.isNaN(num)) {
      return false;
    }

    return num >= 0;
  }
}