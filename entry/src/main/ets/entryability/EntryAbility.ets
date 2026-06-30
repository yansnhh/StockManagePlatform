import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import { DatabaseManager } from '../repositories/DatabaseManager';
import common from '@ohos.app.ability.common';

export default class EntryAbility extends UIAbility {

  async onCreate(
    want: Want,
    launchParam: AbilityConstant.LaunchParam
  ): Promise<void> {
    console.info('Ability created');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {

    console.info('>>> UI stage created');

    const context = this.context as common.UIAbilityContext;

    // 🚀 关键：确保DB一定在UI前初始化完成
    await DatabaseManager.init(context);

    windowStage.loadContent('pages/ProductListPage', (err) => {

      if (err) {
        console.error('load failed', err);
        return;
      }

      console.info('>>> loadContent success');
    });
  }
}