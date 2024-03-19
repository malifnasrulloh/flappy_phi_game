import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flappy_phi/components/background.dart';
import 'package:flappy_phi/components/bird.dart';
import 'package:flappy_phi/components/ground.dart';
import 'package:flappy_phi/components/pipe_group.dart';
import 'package:flappy_phi/components/question.dart';
import 'package:flappy_phi/controllers/game_controller.dart';
import 'package:flappy_phi/game/configuration.dart';
import 'package:flutter/painting.dart';

class FlappyPhiGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyPhiGame();

  late Bird bird;
  late Question question;
  late TextComponent score;

  Timer interval = Timer(Config.pipeInterval, repeat: true);
  bool isHit = false;

  @override
  Future<void> onLoad() async {
    gameController.size.addAll([min(size.x, size.y), max(size.x, size.y)]);

    addAll([
      score = buildScore(),
      Background(),
      bird = Bird(),
      question = Question()
    ]);

    Question.generate();
    interval.onTick = () => addAll([PipeGroup(), Ground()]);
  }

  TextComponent buildScore() {
    return TextComponent(
        priority: 1,
        position: Vector2(size.x / 2, size.y - Config.groundHeight * 0.5),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 40, fontFamily: 'Game', fontWeight: FontWeight.bold),
        ));
  }

  @override
  void onTap() {
    bird.fly();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
    score.text = 'Score: ${bird.score}';
  }
}
