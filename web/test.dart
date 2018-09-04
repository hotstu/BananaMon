import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:image/image.dart';
import 'package:vector_math/vector_math.dart';

import 'src/lib/timer_stream.dart';

class AdvanceAnimator {
  StreamController<int> _controller;
  Timer _timer;
  AdvanceAnimator() {
     _controller = StreamController(onListen: _onListen, onCancel: _onCancel);
  }

  Stream<int> get stream => _controller.stream;

  _onListen() {
    _timer = Timer.periodic(Duration(seconds: 1), _tick);
  }

  _onCancel() {
    print("onCancel");
    _timer.cancel();
    _timer = null;
    if(!_controller.isClosed) {
      _controller.close();
    }
  }

  _tick(Timer t) {
    if(t.tick > 3) {
      _controller.close();
    } else{
      _controller.add(t.tick);
    }
    //print("${t.tick}");
  }


}

acall() async {
  for (var i = 0; i < 100; ++i) {
    await print(i);

  }
}

void main()  {
  TimerStream(Duration(milliseconds: 1000), 1).stream.listen((_) {
    print(_);
  },onError: (e) =>print(e), onDone: () =>print("done") );


}