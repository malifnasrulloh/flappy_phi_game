import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flappy_phi/components/question.dart';
import 'package:flappy_phi/game/assets.dart';
import 'package:flappy_phi/game/configuration.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';

class Ground extends ParallaxComponent<FlappyPhiGame>
    with HasGameRef<FlappyPhiGame> {
  Ground();

  @override
  Future<void> onLoad() async {
    final ground = await Flame.images.load(Assets.ground);
    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(ground, fill: LayerFill.none),
      ),
    ]);
    addAll(
      [
        RectangleHitbox(
          position: Vector2(0, gameRef.size.y - Config.groundHeight),
          size: Vector2(gameRef.size.x, Config.groundHeight),
        ),
        Question()
      ],
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Config.gameSpeed;
  }
}
