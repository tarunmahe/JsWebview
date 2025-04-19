import { WebPlugin } from '@capacitor/core';

import type { AdmobControllerPlugin } from './definitions';

export class AdmobControllerWeb extends WebPlugin implements AdmobControllerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
