import 'dart:collection';
import 'dart:html';

import '../game.dart' as base;
import '../scene.dart';

class Game implements base.Game {
  double lastEslapedtime;
  bool started;

  Map<String, Scene> map;
  String senceName;

  Game() {
    lastEslapedtime = 0.0;
    started = false;
    map = new HashMap();
  }

  void add(String name, Scene scene) {
    map[name] = scene;
  }

  @override
  void start(String name, [attr]) {
    print("start scene $name, attr=$attr");
    map[senceName]?.destroy();
    print("start scene 2");
    senceName = name;
    map[senceName]?.reset(attr);
    map[senceName]?.resume();
    print("start scene 3");
    if (!started) {
      started = true;
      loop();
    }
  }

  void resume() {
    map[senceName]?.resume();
    if (!started) {
      started = true;
      loop();
    }
  }

  @override
  void pause() {
    started = false;
    map[senceName]?.pause();
  }

  @override
  void loop() async {
    if (!started) {
      return;
    }
    double current = await window.animationFrame;
    await update(current - lastEslapedtime);
    lastEslapedtime = current;
    loop();
  }

  @override
  update(double delta) async {
    // print('update at ${lastEslapedtime} - ${delta}' );
    return await map[senceName]?.tick();
  }
}
