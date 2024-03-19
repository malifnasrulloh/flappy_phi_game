import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_phi/components/question.dart';
import 'package:flappy_phi/game/assets.dart';
import 'package:flappy_phi/game/configuration.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';
import 'package:flappy_phi/game/pipe_position.dart';
import 'package:flutter/rendering.dart';

class Pipe extends SpriteComponent with HasGameRef<FlappyPhiGame> {
  Pipe(
      {required this.pipePosition,
      required this.height,
      required this.isAnswer});

  @override
  final double height;
  final PipePosition pipePosition;
  final bool isAnswer;

  @override
  Future<void> onLoad() async {
    final pipe = await Flame.images.load(Assets.pipe);
    final pipeRotated = await Flame.images.load(Assets.pipeRotated);
    size = Vector2(50, height);

    switch (pipePosition) {
      case PipePosition.top:
        position.y = 0;
        sprite = Sprite(pipeRotated);
        break;
      case PipePosition.bottom:
        position.y = gameRef.size.y - size.y - Config.groundHeight;
        sprite = Sprite(pipe);
        break;
    }
    if (isAnswer) {
      add(TextComponent(
          text: Question.answer.toString(),
          position: Vector2(
              size.x / 4 - (Question.answer.toString().length * 12),
              (gameRef.size.y - Config.groundHeight) / 4),
          textRenderer: TextPaint(
              style:
                  const TextStyle(fontFamily: "PixelGameFont", fontSize: 48))));
    } else {
      addAll([
        RectangleHitbox(),
        TextComponent(
            text: Question.wrongAnswer.toString(),
            position: Vector2(
                size.x / 4 - (Question.wrongAnswer.toString().length * 12),
                (gameRef.size.y - Config.groundHeight) / 4),
            textRenderer: TextPaint(
                style:
                    const TextStyle(fontFamily: "PixelGameFont", fontSize: 48)))
      ]);
    }
  }
}
