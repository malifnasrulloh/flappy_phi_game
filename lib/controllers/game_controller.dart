import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_phi/controllers/firebase/account_controller.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class gameController extends GetxController {
  static late FlappyPhiGame game;

  static AudioPlayer backsound = AudioPlayer();

  static List<double> size = [];

  @override
  Future<void> onInit() async {
    game = FlappyPhiGame();
    AccountController.game = game;
    backsound = (await FlameAudio.loopLongAudio("bs.mp3", volume: 25));
    await Flame.device.fullScreen();
    await Flame.device.setOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
    super.onInit();
  }
}
