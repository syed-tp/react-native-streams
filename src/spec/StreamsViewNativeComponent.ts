import { codegenNativeComponent, type ViewProps } from 'react-native';
// @ts-expect-error - CodegenTypes is a runtime module, types are generated at build time
import type { Double } from 'react-native/Libraries/Types/CodegenTypes';

interface NativeProps extends ViewProps {
  assetId: string;
  accessToken: string;
  startAt?: Double;
  shouldAutoPlay?: boolean;
  showDefaultCaptions?: boolean;
  enableDownload?: boolean;
  offlineLicenseExpireTime?: Double;
}

export default codegenNativeComponent<NativeProps>('StreamsView');
