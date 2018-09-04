import 'dart:html';
import 'package:image/image.dart';

import 'src/lib/canvas_wrapper.dart' as base;
import 'src/lib/game.dart';
import 'src/lib/keyboard.dart';
import 'src/lib/web/audio_manager.dart';
import 'src/lib/web/canvas_wrapper.dart';
import 'src/lib/web/game.dart' as impl;
import 'src/scene/gameover_scene.dart';
import 'src/scene/stageloader_scene.dart';
import 'src/stage/stage.dart';
import './src/lib/constants.dart' as constants;
import './src/lib/web/fetch.dart' as fetch;
import 'src/scene/title_scene.dart';
import './src/lib/injection.dart' as inject;


CanvasElement canvas;
CanvasRenderingContext2D ctx;
Game iGame;
Keyboard keyboard = inject.injectKeyboard();


readFile(path) async {
  return fetch.getBytes(path)
  .then((bytes) => readPng(bytes));
//  ImageElement image = new ImageElement(src: path);
//  await image.onLoad.first;
//  CanvasElement canvasElement = CanvasElement(width:constants.logicalWidth, height:constants.logicalHeight);
//  canvasElement.style.imageRendering = "pixelated";
//  CanvasRenderingContext2D ctx = canvasElement.getContext("2d");
//  //ctx.fillRect(0,0,constants.logicalWidth,constants.logicalHeight);
//  ctx.drawImage(image, 0, 0);
//  var dataUrl = canvasElement.toDataUrl();
//  var datUrl2Byte = util.dataUrl2Byte(dataUrl);
//  print(dataUrl);
//  return readPng(datUrl2Byte);

}

main() async {
  canvas = querySelector('#canvas');
  canvas.height = 600;
  canvas.width = 1240;
  base.CanvasWrapper canvasWrapper = CanvasWrapper(canvas, constants.logicalHeight,constants.logicalWidth );
  iGame = impl.Game();
  TitleScene title = TitleScene(iGame, canvasWrapper);
  Stage stage = Stage(iGame, canvasWrapper);
  GameOverScene over = GameOverScene(iGame, canvasWrapper);
  StageLoaderScene loader = StageLoaderScene(iGame, canvasWrapper);
  iGame.add("title", title);
  iGame.add("stage", stage);
  iGame.add("over", over);
  iGame.add("loader", loader);

  AudioManager audioManager = AudioManager();
  await audioManager.init();
  var buttons = querySelectorAll("button");
  buttons.forEach((e) {
    e.addEventListener("click", (event) {
      var target = (event.target as ButtonElement);
      if (target.value == "0") {
        print('start');
        iGame.start("title");
        keyboard.start();
      }
      if (target.value == "1") {
        print('pause');
        iGame.pause();
        keyboard.pause();
      }
      if (target.value == "2") {
        audioManager.play("bomb", true);
      }
    });
  });

}
