import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_player/player/player_controller.dart';
import 'package:getx_player/player/player_controls.dart';
import 'package:video_player/video_player.dart';

class Player extends StatelessWidget {
  final PlayerController controller;

  Player({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      init: controller,
      builder: (_) {
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: Colors.black,
            child: Stack(alignment: Alignment.center, children: [
              _.videoPlayerController != null &&
                      _.videoPlayerController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayer(_.videoPlayerController!))
                  : Container(),
              Obx(() {
                switch (_.sourceStatus) {
                  case SourceStatus.loading:
                    return CircularProgressIndicator();
                  case SourceStatus.none:
                    return Container();
                  case SourceStatus.loaded:
                    return PlayerControls();
                  case SourceStatus.error:
                    return Text(
                      'error',
                      style: TextStyle(color: Colors.white),
                    );
                }
              }),
            ]),
          ),
        );
      },
    );
  }
}
