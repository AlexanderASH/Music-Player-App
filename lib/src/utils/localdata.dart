
import 'package:hive/hive.dart';
import 'package:music_player_app/src/models/Music.dart';
import 'package:music_player_app/src/utils/constants.dart';

class LocalData {
  Box _box;

  Future<void> init(String path) async {
      Hive.init(path);
      Hive.registerAdapter(MusicAdapter());
      await Hive.openBox(DB_NAME);
      this._box = Hive.box(DB_NAME);
      this._loadData();
  }

  void _loadData() {
    if (this._box.get('playedOnce') == null) {
      this._box.put('playedOnce', "false");
    }
  }

  void addValue(dynamic key, dynamic value) {
    this._box.put(key, value);
  }

  dynamic getValue(dynamic key) {
    return this._box.get(key);
  }

  void close() {
    this._box.close();
  }
}