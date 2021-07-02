import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_player/player/player_controller.dart';
import 'package:getx_player/player/slider.dart';
import 'package:getx_player/utils/extras.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      builder: (_) {
        return Positioned.fill(
          child: Obx(() {
            return GestureDetector(
              onTap: _.onShowControls,
              child: AnimatedContainer( duration: Duration(milliseconds: 300),
                color: _.showControls ? Colors.black54 : Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AbsorbPointer(
                      absorbing: !_.showControls,
                      child: AnimatedOpacity(
                        opacity: _.showControls ? 1 : 0,
                        duration: Duration(milliseconds: 300),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PlayerButton(
                                onPressed: _.reWind,
                                size: 50,
                                iconPath: 'assets/icons/rewind.png'),
                            SizedBox(
                              width: 10,
                            ),
                            Obx(() {
                              switch (_.playStatus) {
                                case PlayStatus.stopped:
                                  return PlayerButton(
                                      onPressed: _.play,
                                      size: 60,
                                      iconPath: 'assets/icons/repeat.png');
                                case PlayStatus.playing:
                                  return PlayerButton(
                                      onPressed: _.pause,
                                      size: 60,
                                      iconPath: 'assets/icons/pause.png');
                                case PlayStatus.paused:
                                  return PlayerButton(
                                      onPressed: _.play,
                                      size: 60,
                                      iconPath: 'assets/icons/play.png');
                              }
                            }),
                            SizedBox(
                              width: 10,
                            ),
                            PlayerButton(
                                onPressed: _.fastForWard,
                                size: 50,
                                iconPath: 'assets/icons/fast-forward.png'),
                          ],
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                        duration: Duration(milliseconds: 300),
                        bottom: _.showControls ? 0 : -70.0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.black26,
                          child: Row(
                            children: [
                              Obx(() {
                                return Text(
                                  parseDuration(_.position),
                                  style: TextStyle(color: Colors.white),
                                );
                              }),
                              SizedBox(
                                width: 10,
                              ),
                              SliderP(),
                              SizedBox(
                                width: 10,
                              ),
                              Obx(() {
                                return PlayerButton(
                                    size: 40,
                                    iconPath: _.mute
                                        ? 'assets/icons/mute.png'
                                        : 'assets/icons/sound.png',
                                    circle: false,
                                    backgroundColor: Colors.transparent,
                                    iconColor: Colors.white,
                                    onPressed: _.onMute);
                              }),
                              SizedBox(
                                width: 10,
                              ),
                              Obx(() {
                                return Text(
                                  parseDuration(_.duration),
                                  style: TextStyle(color: Colors.white),
                                );
                              }),
                              Obx(() {
                                return PlayerButton(
                                    size: 40,
                                    iconPath: _.fullscreen
                                        ? 'assets/icons/minimize.png'
                                        : 'assets/icons/fullscreen.png',
                                    circle: false,
                                    backgroundColor: Colors.transparent,
                                    iconColor: Colors.white,
                                    onPressed: _.onFullscreen);
                              }),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class PlayerButton extends StatelessWidget {
  final double size;
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgroundColor, iconColor;
  final bool circle;

  const PlayerButton(
      {Key? key,
      required this.size,
      required this.iconPath,
      required this.onPressed,
      this.backgroundColor = Colors.white54,
      this.iconColor = Colors.black,
      this.circle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              color: backgroundColor,
              shape: circle ? BoxShape.circle : BoxShape.rectangle),
          padding: EdgeInsets.all(size * 0.15),
          child: Image.asset(
            iconPath,
            color: iconColor,
          ),
        ),
        onPressed: onPressed);
  }
}
