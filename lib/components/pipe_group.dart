import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_phi/components/question.dart';
import 'package:flappy_phi/game/assets.dart';
import 'package:flappy_phi/game/configuration.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';
import 'package:flappy_phi/game/pipe_position.dart';
import 'package:flappy_phi/components/pipe.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyPhiGame> {
  PipeGroup();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final heightMinusGround = gameRef.size.y - Config.groundHeight;

    addAll([
      Pipe(
          pipePosition: PipePosition.top,
          height: heightMinusGround / 2,
          isAnswer: Question.indexAnswer == 0 ? true : false),
      Pipe(
          pipePosition: PipePosition.bottom,
          height: heightMinusGround / 2,
          isAnswer: Question.indexAnswer == 1 ? true : false),
    ]);
  }

  void updateScore() {
    gameRef.bird.score += 1;

    Question.scaleNum += gameRef.bird.score % 10 == 0 ? 1 : 0;

    Question.generate();
    FlameAudio.play(Assets.point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
    }
  }
}
