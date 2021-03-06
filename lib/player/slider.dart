import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_player/player/player_controller.dart';
import 'package:getx_player/utils/extras.dart';

class SliderP extends StatelessWidget {
  const SliderP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      builder: (_) {
        return Expanded(
            child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              child: LayoutBuilder(builder: (ctx, constrains) {
                return Obx(() {
                  double percent = 0.00;
                  if (_.bufferedLoaded.inSeconds > 0) {
                    percent = _.bufferedLoaded.inSeconds / _.duration.inSeconds;
                  }
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 5,
                    color: Colors.white12,
                    width: constrains.maxWidth * percent,
                  );
                });
              }),
            ),
            Obx(() {
              final value = _.sliderPosition.inSeconds;
              final max = _.duration.inSeconds.toDouble();
              if (value > max || max <= 0) return Container();
              return  SliderTheme(
                data:SliderThemeData(
                  trackShape: MSliderTrackShape(),
                ),
                child: Slider(
                    min: 0,
                    divisions: _.duration.inSeconds,
                    value: value.toDouble(),
                    onChangeStart: (v) => _.onChangedSliderStart(),
                    onChangeEnd: (v) {
                      _.onChangedSliderEnd();
                      _.seekTo(Duration(seconds: v.floor()));
                    },
                    label: parseDuration(_.sliderPosition),
                    max: max,
                    onChanged: _.onChangedSlider,
                  ),
              );
            }),
          ],
        ));
      },
    );
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    return Rect.fromLTWH(
      offset.dx,
      offset.dy + parentBox.size.height / 2 - 2,
      parentBox.size.width,
      4,
    );
  }
}