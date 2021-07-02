import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_player/controllers/home.dart';
import 'package:getx_player/player/player.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Container(
                width: size.width,
                height: size.height,
                child: OrientationBuilder(builder: (ctx, orientation) {
                  final player =
                      Player(key: _.playerKey, controller: _.playerController!);
                  final videoList = ListView.builder(
                    itemBuilder: (__, index) {
                      final video = _.videos[index];
                      return ListTile(
                        onTap: () => _.play(video.url),
                        leading: Image.network(video.image),
                        title: Text(video.title),
                        subtitle: Text(
                          video.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                    itemCount: _.videos.length,
                  );
                  if (orientation == Orientation.portrait) {
                    return Column(
                      children: [player, Expanded(child: videoList)],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: player,
                        flex: 1,
                      ),
                      Expanded(
                        child: videoList,
                        flex: 1,
                      )
                    ],
                  );
                })),
          ),
        );
      },
    );
  }
}
