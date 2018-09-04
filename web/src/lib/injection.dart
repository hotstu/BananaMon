import 'audio_manager.dart' as base;
import 'web/audio_manager.dart' as impl;
import 'keyboard.dart' as base1;
import 'web/keyboard.dart' as impl1;
import 'level_provider.dart' as base2;
import 'web/level_provider.dart' as impl2;
import 'web/resourcProvider.dart';
//提供所有单例的入口

base.AudioManager injectAudio() {
  return impl.AudioManager();
}

ResourceProvider injectResourceProvider() {
  return ResourceProvider();
}

base1.Keyboard injectKeyboard() {
  return impl1.Keyboard();
}

base2.LevelProvider injectLevelProvider() {
  return impl2.LevelProvider();
}

