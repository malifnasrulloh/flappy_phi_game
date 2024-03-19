import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_phi/game/assets.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyPhiGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.backgorund);
    size = gameRef.size;
    sprite = Sprite(background);
  }
}
