import 'package:flutter/material.dart';
import 'package:getx_player/player/player.dart';
import 'package:getx_player/player/player_controller.dart';

class PlayerFullScreen extends StatelessWidget {
  final PlayerController playerController;

  const PlayerFullScreen({Key? key, required this.playerController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(body: Container(
        width: size.width,
        height: size.height,
        child: Player(controller: playerController)));
  }
}
