import 'dart:html';
import 'package:image/image.dart';
import 'package:vector_math/vector_math.dart';

import '../lib/web/canvas_wrapper.dart';
import '../stage/stage_model.dart';
import '../stage/mapItem_type.dart';
import '../lib/constants.dart' as constants;

const pysical_width = 1200;//css width
const pysical_height = 600;//css heght
const logical_width = constants.logicalWidth;
const logical_height = constants.logicalHeight;

MapItemType currentType = MapItemType.Wall1;


CanvasWrapper canvasWrapper;
StageModel sm;


void updateRect(Point rawRect) {
  var vclient = canvasWrapper.py2loProjection(Vector2(rawRect.x, rawRect.y));
  var client = Point(vclient.x.toInt(), vclient.y.toInt());

  sm.setState(client.x, client.y, currentType);
  canvasWrapper.setBrush(sm.getColor(client.x, client.y));
  canvasWrapper.clearRect(client.x, client.y);
  canvasWrapper.fillRect(client.x, client.y);
  int count = sm.getCount(client.x, client.y);
  if(count > 0) {
    canvasWrapper.setBrush("white");
    canvasWrapper.fillText( client.x, client.y, count.toString());
  }
}

/**
 * 从图片中恢复状态
 */
void restoreFromFile(File f) {
  print("resotre from ${f.name}...");
  FileReader fr = new FileReader();
  fr.readAsArrayBuffer(f);
  fr.onLoadEnd.first.then((ProgressEvent e) {
    Image image = decodeImage(fr.result);
    assert(image.height == logical_height && image.width == logical_width);
    sm = StageModel.fromImage(canvasWrapper, image);
    for (var i = 0; i < logical_width; ++i) {
      for (var j = 0; j < logical_height; ++j) {
        Point client = new Point(i, j);
        canvasWrapper.setBrush(sm.getColor(client.x, client.y));
        canvasWrapper.clearRect(client.x, client.y);
        canvasWrapper.fillRect(client.x, client.y);
        int count = sm.getCount(client.x, client.y);
        if(count > 0) {
          canvasWrapper.setBrush("white");
          canvasWrapper.fillText(client.x, client.y, count.toString());
        }
      }
    }
    print("restore done!");

  });
}

void download() {
  new AnchorElement()
    ..href = sm.exportBitmap()
    ..download = 'image.png'
    ..click();
}

void main() {
  CanvasElement canvas = querySelector('#canvas');
  canvas.width = pysical_width;
  canvas.height = pysical_height;
  canvasWrapper = CanvasWrapper(canvas, logical_height, logical_width);
  sm = new StageModel(canvasWrapper, logical_width,logical_height);

  canvas.addEventListener("click", (e) {
    MouseEvent event = e as MouseEvent;
    updateRect(event.offset);
  });
  var buttons = querySelectorAll("button");
  buttons.forEach((ele) {
    ele.addEventListener("click", (e) {
      var v = (e.target as ButtonElement).value;
      if(v == "download") {
        download();
      } else {
        int type = int.parse(v);
        print("${type} clicked");
        currentType = MapItemType.values[type];
      }
    });
  });
  InputElement fileupload1 = querySelector("#fileupload1");
  fileupload1.addEventListener("change", (e) {
    if(fileupload1.files.isNotEmpty) {
      File f = fileupload1.files[0];
      restoreFromFile(f);
    }
  });
}
