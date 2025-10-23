import { codegenNativeComponent, type ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  assetId: string;
  accessToken: string;
}

export default codegenNativeComponent<NativeProps>('StreamsView');
