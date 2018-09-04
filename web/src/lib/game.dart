import 'scene.dart';

abstract class Game {
  void add(String name, Scene scene );
  void start(String name, [attr]);
  void pause();
  void resume();
  void loop();
  void update(double delta);
}