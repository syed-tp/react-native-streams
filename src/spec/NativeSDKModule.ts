import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  initialize(organizationId: string): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('SDKModule');
