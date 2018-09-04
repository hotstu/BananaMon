
import 'game.dart';

abstract class Scene  {
  static final int SCENE_STATE_INT = 0;
  static final int SCENE_STATE_READY = 1;
  static final int SCENE_STATE_DESTORY = 2;
  int state = SCENE_STATE_INT;
  var attr;
  Game get game;
  void reset(attr) {
    this.attr = attr;
    state = SCENE_STATE_INT;
  }
  void pause(){}
  void resume(){}
  void destroy(){}
  void tick();
}