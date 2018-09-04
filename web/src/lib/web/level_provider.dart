import '../level_provider.dart' as base;
import 'fetch.dart' as fetch;

class LevelProvider extends base.LevelProvider {
  static LevelProvider instance;

  LevelProvider._init();

  factory LevelProvider() {
    if (instance == null) {
      instance = LevelProvider._init();
    }
    return instance;
  }

  @override
  getRawData(String name) async {
    final path = "/resource/level/${name}.png";
    return await fetch.getBytes(path);
  }
}
