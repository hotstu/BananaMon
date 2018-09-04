import 'dart:async';
import 'dart:collection';

import 'dart:html';

import '../../char/mixin/keyboardWatcher.dart';
import '../keyboard.dart' as base;
import '../constants.dart' as constants;

/**
 * keyboard is a singleton
 */
class Keyboard extends base.Keyboard {
  static Keyboard instance;

  HashMap<int, num> _keys = new HashMap<int, num>();
  List<KeyBoardWatcher> listeners;
  StreamSubscription keydownSub;
  StreamSubscription keyupSub;

  Keyboard._internal() {
    listeners = [];
  }

  @override
  void start() {
    if (keydownSub != null) {
      if (keydownSub.isPaused) {
        keydownSub.resume();
      }
      return;
    }
    keydownSub = window.onKeyDown.listen((KeyboardEvent event) {
      print(event.keyCode);
      _keys.putIfAbsent(event.keyCode, () => event.timeStamp);
      listeners.forEach((watcher) {
        watcher.onKeyDown(_mappingRev(event.keyCode));
      });
    });

    keyupSub = window.onKeyUp.listen((KeyboardEvent event) {
      _keys.remove(event.keyCode);
      listeners.forEach((watcher) {
        watcher.onKeyUp(_mappingRev(event.keyCode));
      });
    });
  }

  @override
  void pause() {
    if (keydownSub == null || keydownSub.isPaused) {
      return;
    }
    keydownSub.pause();
    keyupSub.pause();
  }

  @override
  void stop() {
    keydownSub.cancel();
    keyupSub.cancel();
    keydownSub = null;
    keyupSub = null;
  }

  factory Keyboard() {
    if (instance == null) {
      instance = Keyboard._internal();
    }
    return instance;
  }

  @override
  String toString() => _keys.toString();

  int _mapping(int gen) {
    switch (gen) {
      case constants.keyLeft:
        return 0x25;
      case constants.keyUp:
        return 0x26;
      case constants.keyRight:
        return 0x27;
      case constants.keyDown:
        return 0x28;
      case constants.keyA:
        return 0x58;
      case constants.keyB:
        return 0x5a;
    }
    return 0;
  }

  int _mappingRev(int gen) {
    switch (gen) {
      case 0x25:
        return constants.keyLeft;
      case 0x26:
        return constants.keyUp;
      case 0x27:
        return constants.keyRight;
      case 0x28:
        return constants.keyDown;
      case 0x58:
        return constants.keyA;
      case 0x5a:
        return constants.keyB;
    }
    return 0;
  }

  bool isPressed(int keyCode) => _keys.containsKey(_mapping(keyCode));

  @override
  addListener(KeyBoardWatcher watcher) async {
    return Future.delayed(Duration.zero, () {
      if (listeners.indexOf(watcher) == -1) {
        listeners.add(watcher);
      }
    });
  }

  @override
  removeListener(KeyBoardWatcher watcher) async {
    return Future.delayed(Duration.zero, () {
      listeners.remove(watcher);
    });
  }
}
