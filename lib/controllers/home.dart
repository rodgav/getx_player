import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_player/models/video.dart';
import 'package:getx_player/player/player_controller.dart';
import 'package:getx_player/utils/videos.dart' as v;

class HomeController extends GetxController {
  List<Video> _videos = [];

  List<Video> get videos => _videos;

  final GlobalKey playerKey = GlobalKey();

  PlayerController? _playerController;

  PlayerController? get playerController => _playerController;

  @override
  void onInit() {
    if (Get.context!.isTablet) {
      _playerController = PlayerController(DeviceOrientation.values);
    }
    _playerController = PlayerController(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.onInit();
  }

  @override
  void onReady() {
    this._videos = v.videos.map((e) => Video.fromJson(e)).toList();
    update();
    playerController?.loadVideo(
        'https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov');
    super.onReady();
  }

  Future<void> play(String url) async {
    await playerController!.loadVideo(url,autoplay: true);
  }

  @override
  void onClose() {
    playerController?.dispose();
    super.onClose();
  }
}
