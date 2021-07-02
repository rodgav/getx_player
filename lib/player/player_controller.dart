import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_player/player/player_fullscreen.dart';
import 'package:video_player/video_player.dart';

enum SourceStatus { none, loading, loaded, error }
enum PlayStatus { stopped, playing, paused }

class PlayerController extends GetxController {
  final List<DeviceOrientation> defaultOrientations;

  PlayerController(this.defaultOrientations);

  VideoPlayerController? _videoPlayerController;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;

  Rx<SourceStatus> _sourceStatus = SourceStatus.none.obs;
  Rx<PlayStatus> _playStatus = PlayStatus.stopped.obs;

  SourceStatus get sourceStatus => _sourceStatus.value;

  PlayStatus get playStatus => _playStatus.value;

  Rx<Duration> _position = Duration.zero.obs;
  Rx<Duration> _sliderPosition = Duration.zero.obs;
  Rx<Duration> _duration = Duration.zero.obs;
  Rx<Duration> _bufferedLoaded = Duration.zero.obs;

  Duration get position => _position.value;

  Duration get sliderPosition => _sliderPosition.value;

  Duration get duration => _duration.value;

  Duration get bufferedLoaded => _bufferedLoaded.value;

  bool _isSldierMoving = false;
  Rx<bool> _mute = false.obs;
  Rx<bool> _fullscreen = false.obs;
  Rx<bool> _showControls = false.obs;

  bool get mute => _mute.value;

  bool get fullscreen => _fullscreen.value;

  bool get showControls => _showControls.value;

  Timer? _timer;

  Future<void> loadVideo(String url, {bool autoplay = true}) async {
    try {
      _sourceStatus.value = SourceStatus.loading;

      VideoPlayerController? tmp;

      if (_videoPlayerController != null) {
        pause();
        tmp = _videoPlayerController!;
      }

      _videoPlayerController = VideoPlayerController.network(url);
      await _videoPlayerController!.initialize();
      final duration = _videoPlayerController!.value.duration;
      if (this.duration.inSeconds != duration.inSeconds)
        _duration.value = duration;

      _videoPlayerController!.addListener(() {
        final position = _videoPlayerController!.value.position;
        _position.value = position;

        if (!_isSldierMoving) _sliderPosition.value = position;

        if (_position.value.inSeconds >= duration.inSeconds &&
            playStatus != PlayStatus.stopped)
          _playStatus.value = PlayStatus.stopped;

        final buffered = _videoPlayerController!.value.buffered;
        if (buffered.isNotEmpty) _bufferedLoaded.value = buffered.last.end;
      });
      _sourceStatus.value = SourceStatus.loaded;
      update();
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        if (tmp != null) {
          await tmp?.dispose();
          tmp = null;
        }
      });
      if (autoplay) await play();
    } catch (e) {
      print('error error $e');
      _sourceStatus.value = SourceStatus.error;
    }
  }

  Future<void> play() async {
    if (playStatus == PlayStatus.stopped || playStatus == PlayStatus.paused) {
      if (playStatus == PlayStatus.stopped) {
        await seekTo(Duration.zero);
      }
      await _videoPlayerController!.play();
      _playStatus.value = PlayStatus.playing;
    }
  }

  Future<void> pause() async {
    if (playStatus == PlayStatus.playing) {
      await _videoPlayerController!.pause();
      _playStatus.value = PlayStatus.paused;
    }
  }

  Future<void> seekTo(Duration position) async {
    await _videoPlayerController!.seekTo(position);
  }

  Future<void> fastForWard() async {
    final to = position.inSeconds + 10;
    if (duration.inSeconds > to) {
      await seekTo(Duration(seconds: to));
    }
  }

  Future<void> reWind() async {
    final to = position.inSeconds - 10;
    await seekTo(Duration(seconds: to < 0 ? 0 : to));
  }

  void onChangedSliderStart() {
    _isSldierMoving = true;
  }

  void onChangedSliderEnd() async {
    _isSldierMoving = false;
    if (playStatus == PlayStatus.stopped) {
      await _videoPlayerController!.play();
      _playStatus.value = PlayStatus.playing;
    }
  }

  onChangedSlider(double v) {
    _sliderPosition.value = Duration(seconds: v.floor());
  }

  Future<void> onMute() async {
    _mute.value = !mute;
    await _videoPlayerController!.setVolume(mute ? 0 : 1);
  }

  onShowControls() {
    _showControls.value = !showControls;
    if (_timer != null) {
      _timer?.cancel();
    }
    if (showControls) {
      _hideTaskControls();
    }
  }

  void _hideTaskControls() {
    _timer = Timer(Duration(seconds: 5), () {
      onShowControls();
      _timer = null;
    });
  }

  Future<void> onFullscreen() async {
    _fullscreen.value = !fullscreen;
    if (fullscreen) {
      await _fullScreenOn();
    } else {
      Get.back();
    }
  }

  _fullScreenOn() async {
    await SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await Get.to(PlayerFullScreen(playerController: this),
        transition: Transition.fade, duration: Duration.zero);
    _fullscreen.value = false;
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(defaultOrientations);
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _videoPlayerController?.dispose();
  }
}
