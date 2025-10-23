import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';
import { initializeStreamsSDK } from 'react-native-streams';

initializeStreamsSDK('9q94nm');

AppRegistry.registerComponent(appName, () => App);
