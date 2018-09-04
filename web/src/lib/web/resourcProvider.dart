import 'dart:async';
import 'dart:convert';
import 'dart:html';
import '../constants.dart' as constants;
import '../sprite.dart';
import 'fetch.dart' as fetch;

readFile(path) async {
  ImageElement image = new ImageElement(src: path);
  await image.onLoad.first;
  return image;
}

class ResourceProvider {
  static ResourceProvider instance;
  CanvasImageSource wall;
  CanvasImageSource wallsolid;
  CanvasImageSource huaji;
  CanvasImageSource hero1;
  CanvasImageSource bomb1;
  CanvasImageSource explosion;
  CanvasImageSource blocck_destory;
  CanvasImageSource monster_destory;
  CanvasImageSource treasures;
  CanvasImageSource gate;
  Map desc;

  ResourceProvider._init();

  factory ResourceProvider() {
    if (instance == null) {
      instance = ResourceProvider._init();
    }
    return instance;
  }

  Stream<int> init() {
    StreamController<int> controller;
    controller = StreamController(onListen: () async {
      if (desc == null) {
        wall = await readFile("/resource/sprite_bricks.png");
        //TODO 返回具体文件大小
        //TODO 并行加载
        controller.add(1);
        wallsolid = await readFile("/resource/sprite_bricks_solid.png");
        controller.add(2);
        huaji = await readFile("/resource/huaji90x90.png");
        controller.add(3);
        hero1 = await readFile("/resource/hero1.png");
        controller.add(4);
        bomb1 = await readFile("/resource/bomb1.png");
        controller.add(5);
        explosion = await readFile("/resource/explosion.png");
        controller.add(6);
        blocck_destory = await readFile("/resource/block_destory.png");
        controller.add(7);
        monster_destory = await readFile("/resource/monster_destory.png");
        controller.add(8);
        treasures = await readFile("/resource/treasure.png");
        controller.add(9);
        gate = await readFile("/resource/gate.png");
        controller.add(10);
        desc = jsonDecode(await fetch.get("/resource/desc.json"));
        controller.add(11);
      }

      //print(desc);
      controller.close();
    });
    return controller.stream;
  }

  CanvasImageSource obtainSoureByName(String name) {
    switch (name) {
      case constants.sourceIdWall1:
        return wall;
      case constants.sourceIdWall2:
        return wallsolid;
      case constants.sourceIdMonster1:
        return huaji;
      case constants.sourceIdHero1:
        return hero1;
      case constants.sourceIdBomb1:
        return bomb1;
      case constants.sourceIdExplosion1:
        return explosion;
      case constants.sourceIdDestory1:
        return blocck_destory;
      case constants.sourceIdDestory2:
        return monster_destory;
      case constants.sourceIdTreasure1:
        return treasures;
      case constants.sourceIdGate1:
        return gate;
      default:
        return wall;
    }
  }

  List<Sprite> _create(String type, List rects) {
    //print("_create${rects.length}");

    assert(rects != null && rects.length % 8 == 0);
    List<Sprite> ret = [];
    for (var i = 0; i < rects.length; i += 8) {
      Sprite s = new Sprite.fromValues(
          type,
          rects[i],
          rects[i + 1],
          rects[i + 2],
          rects[i + 3],
          rects[i + 4],
          rects[i + 5],
          rects[i + 6],
          rects[i + 7]);
      ret.add(s);
    }
    return ret;
  }

  List<Sprite> obtainSoureDesc(String type) {
    switch (type) {
      case constants.sourceIdWall1:
        return _create(type, desc["sprite_bricks"]);
      case constants.sourceIdWall2:
        return _create(type, desc["sprite_bricks_solid"]);
      case constants.sourceIdMonster1:
        return _create(type, desc["huaji90x90"]);
      case constants.sourceIdHero1:
        return _create(type, desc["hero1"]);
      case constants.sourceIdBomb1:
        return _create(type, desc["bomb1"]);
      case constants.sourceIdExplosion1:
        return _create(type, desc["explosion"]);
      case constants.sourceIdDestory1:
      case constants.sourceIdDestory2:
        return _create(type, desc["destroy"]);
      case constants.sourceIdTreasure1:
        return _create(type, desc["treasure"]);
      case constants.sourceIdGate1:
        return _create(type, desc["gate"]);
      default:
        break;
    }
    return _create(type, desc["sprite_bricks"]);
  }
}
