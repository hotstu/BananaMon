import 'dart:async';
import 'dart:web_audio';
import '../audio_manager.dart' as base;
import 'fetch.dart' as fetch;

class AudioManager implements base.AudioManager {
  AudioContext ctx;
  static AudioManager instance;

  Map<String, AudioBuffer> buffers;

  AudioManager._internal() {
    ctx = AudioContext();
  }

  factory AudioManager() {
    if (instance == null) {
      instance = AudioManager._internal();
    }
    return instance;
  }

  Stream<int> init() {
    StreamController<int> controller;
    controller = StreamController(onListen: () async {
      if(buffers ==null) {
        buffers = Map();
        //TODO 并行加载 Future.wait
        buffers["bomb"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/bomb.ogg")).buffer);
        controller.add(1);
        buffers["click"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/click.ogg")).buffer);
        controller.add(2);

        buffers["powerup"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/powerup.ogg")).buffer);
        controller.add(3);
        buffers["opening"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/01_Title Screen.mp3")).buffer);
        controller.add(4);

        buffers["starting"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/02_Stage Start.mp3")).buffer);
        controller.add(5);
        buffers["playing"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/03_Stage Theme.mp3") ).buffer);
        controller.add(6);
        buffers["Life Lost"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/08_Life Lost.mp3")).buffer);
        controller.add(7);
        buffers["Stage Complete"] = await ctx.decodeAudioData((await fetch.getBytes("/resource/audio/05_Stage Complete.mp3")).buffer);
        controller.add(8);
      }
      controller.close();
    });
    return controller.stream;
  }

  @override
  SoundPlay play(String name, [loop = false]) {
    AudioBufferSourceNode source = ctx.createBufferSource();
    source.buffer = buffers[name];
    source.connectNode(ctx.destination);
    SoundPlay play = SoundPlay(source);
    play.loop = loop;
    play.start();
    return play;
  }
}

class SoundPlay implements base.SoundPlay {
  AudioBufferSourceNode source;
  bool _playing = false;

  SoundPlay(this.source);

  set loop(bool v) {
    source.loop = v;
  }

  @override
  bool get loop => source.loop;

  @override
  bool get playing => _playing;

  @override
  void start() {
    _playing = true;
    source.start();
  }

  @override
  void stop() {
    _playing = false;
    source.stop();
  }

  @override
  void toggle() {
    _playing ? stop() : start();
    _playing = !_playing;
  }
}
