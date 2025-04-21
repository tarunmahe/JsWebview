import { WebPlugin } from '@capacitor/core';

import type { AdmobControllerPlugin } from './definitions';

export class AdmobControllerWeb extends WebPlugin implements AdmobControllerPlugin {
  async open(options: { url: string; showCloseButton?: boolean }): Promise<void> {
    console.log('Opening URL in web fallback:', options.url);
    console.log('Show close button:', options.showCloseButton);
    window.open(options.url, '_blank');
  }

  async close(): Promise<void> {
    console.log('Close called in web fallback');
    // No-op in web implementation as we can't close windows we didn't create
  }
}
