export { default as StreamsView } from './spec/StreamsViewNativeComponent';
export * from './spec/StreamsViewNativeComponent';

import SDKModule from './spec/NativeSDKModule';
export const { initialize: initializeStreamsSDK } = SDKModule;
