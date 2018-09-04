import 'dart:html';
import 'package:image/image.dart';
import 'package:vector_math/vector_math.dart';

import '../canvas_wrapper.dart' as base;
import '../sprite.dart';
import 'resourcProvider.dart';
import '../injection.dart' as inject;


class CanvasWrapper implements base.CanvasWrapper {
  final CanvasElement canvas;
  final CanvasRenderingContext2D ctx;
  final ResourceProvider resourceProvider;
  final int p_width;
  final int p_height;
  final int l_width;
  final int l_height;
  final int CELL_SIZE_W;
  final int CELL_SIZE_H;

  CanvasWrapper(this.canvas, this.l_height, this.l_width)
      : assert(canvas != null),
        ctx = canvas.getContext('2d'),
        p_width = canvas.width,
        p_height = canvas.height,
        resourceProvider = inject.injectResourceProvider(),
        CELL_SIZE_W = 40,
        CELL_SIZE_H = 40;

  @override
  void setBrush(String color) {
    ctx.fillStyle = color;
    ctx.strokeStyle = color;
  }

  @override
  num measureText(String text) {
    return ctx.measureText(text).width;
  }

  @override
  void setFont(String font) {
    ctx.font = font;
  }
  @override
  void clearRect(int x, int y) {
    var pyP = lo2pyProjection(Vector2(x.toDouble(), y.toDouble()));
    ctx.clearRect(pyP.x, pyP.y, CELL_SIZE_W, CELL_SIZE_H);
  }
  @override
  void fillRect(int x, int y) {
    var pyP = lo2pyProjection(Vector2(x.toDouble(), y.toDouble()));
    ctx.fillRect(pyP.x, pyP.y, CELL_SIZE_W, CELL_SIZE_H);
  }

  @override
  void fillText(int x, int y, String text) {
    var pyP = lo2pyProjection(Vector2(x.toDouble(), y.toDouble()));
    ctx.fillText(text, pyP.x + .5 * CELL_SIZE_W, pyP.y + .5 * CELL_SIZE_H, CELL_SIZE_W);
  }

  @override
  void rfillText(num x, num y, String text,[num maxWidth]) {
    ctx.fillText(text, x , y, maxWidth);
  }

  @override
  Vector2 py2loProjection(Vector2 p) {
    num x = (p.x) * l_width ~/ p_width;
    num y = (p.y) * l_height ~/ p_height;
    return Vector2(x, y);
  }

  @override
  Vector2 lo2pyProjection(Vector2 p) {
    num x = (p.x) / l_width * p_width;
    num y = (p.y) / l_height * p_height;
    return Vector2(x, y);
  }

  // Draw an Image onto a Canvas by getting writing the bytes to ImageData that can be
  // copied to the Canvas.
  static void _drawImageOntoCanvas(CanvasElement canvas, Image image) {
    var imageData = canvas.context2D.createImageData(image.width, image.height);
    imageData.data.setRange(0, imageData.data.length, image.getBytes());
    // Draw the buffer onto the canvas.
    canvas.context2D.putImageData(imageData, 0, 0);
  }

  String exportBitmap(image) {
    CanvasElement canvas = Element.canvas();
    canvas.width = image.width;
    canvas.height = image.height;
    _drawImageOntoCanvas(canvas, image);
    return canvas.toDataUrl();
  }

  @override
  void rclearRect(num x, num y) {
    if (x == -1 && y == -1) {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    } else {
      ctx.clearRect(x, y, CELL_SIZE_W, CELL_SIZE_H);
    }
  }

  @override
  void rfillRect(num x, num y) {
    ctx.fillRect(x, y, CELL_SIZE_W, CELL_SIZE_H);
  }

  CanvasImageSource _obtainSoureByName(String name) {
    // all the image source should managed by this instance;
    return resourceProvider.obtainSoureByName(name);
  }

  @override
  void rdrawImage(Sprite drawable, Rectangle<num> rect) {
    Rectangle<num> dRect = Rectangle(
        rect.left + drawable.dst.left,
        rect.top + drawable.dst.top,
        drawable.dst.width <= 0 ? CELL_SIZE_W : drawable.dst.width,
        drawable.dst.height <= 0 ? CELL_SIZE_H : drawable.dst.height);
    ctx.drawImageToRect(_obtainSoureByName(drawable.sourceId), dRect, sourceRect: drawable.rect);
  }

  @override
  List<Sprite> obtainSoureDesc(String type) {
    return resourceProvider.obtainSoureDesc(type);
  }

  @override
  num get height => p_height;

  @override
  num get width => p_width;

  @override
  void restore() {
    ctx.restore();
  }

  @override
  void save() {
    ctx.save();
  }

  @override
  void translate(num x, num y) {
    ctx.translate(x, y);
  }

  @override
  void scale(num x, num y) {
    ctx.scale(x, y);
  }

  @override
  void transform(num a,num b,num c,num d,num e,num f) {
    ctx.transform(a, b, c, d, e, f);
  }
  @override
  void rotate(num angle) {
    ctx.rotate(angle);
  }
}
