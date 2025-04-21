export interface AdmobControllerPlugin {
  /**
   * Opens a WebView with the provided URL
   * @param options Options containing the URL to open and whether to show a close button
   */
  open(options: { url: string; showCloseButton?: boolean }): Promise<void>;

  /**
   * Closes the currently open WebView
   */
  close(): Promise<void>;
}
