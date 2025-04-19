import { registerPlugin } from '@capacitor/core';

import type { AdmobControllerPlugin } from './definitions';

const AdmobController = registerPlugin<AdmobControllerPlugin>('AdmobController', {
  web: () => import('./web').then((m) => new m.AdmobControllerWeb()),
});

export * from './definitions';
export { AdmobController };
