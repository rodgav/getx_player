import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_version/get_version.dart';

class PictureInPicture {
  PictureInPicture._internal();

  static PictureInPicture _instance = PictureInPicture._internal();

  static PictureInPicture get instance => _instance;

  final _channel = MethodChannel("app.rsgmsolutions/player");

  pip() async {
    if (GetPlatform.isAndroid) {
      String version = await GetVersion.platformVersion;
      version = version.replaceFirst('Android ', '');
      final v = double.parse(version);
      if (v > 7) {
          await _channel.invokeMethod("pip");
      }
    }
  }
}
