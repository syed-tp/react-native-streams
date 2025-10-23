import { View, StyleSheet } from 'react-native';
import { StreamsView } from 'react-native-streams';

export default function App() {
  return (
    <View style={styles.container}>
      <StreamsView
        assetId="57gHcHDBxKX"
        accessToken="5e28479d-69d8-41c7-9664-79b7eb8f1f95"
        style={{ width: '100%', height: 240 }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: '100%',
    height: 250,
    marginVertical: 20,
  },
});
