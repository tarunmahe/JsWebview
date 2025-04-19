export interface AdmobControllerPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
