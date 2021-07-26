
import 'package:hive/hive.dart';
import 'package:music_player_app/src/utils/constants.dart';

class LocalData {
  Box _box;

  Future<void> init(String path) async {
      Hive.init(path);
      await Hive.openBox<String>(DB_NAME);
      this._box = Hive.box<String>(DB_NAME);
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

  void addObject(dynamic value) {
    this._box.add(value);
  }

  dynamic getValue(dynamic key) {
    return this._box.get(key);
  }

  dynamic getAt() {
    return this._box.getAt(1);
  }
}