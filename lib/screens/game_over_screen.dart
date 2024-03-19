import 'package:flappy_phi/controllers/firebase/account_controller.dart';
import 'package:flappy_phi/controllers/game_controller.dart';
import 'package:flappy_phi/game/assets.dart';
import 'package:flappy_phi/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black38,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: ${gameController.game.bird.score}',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(Assets.gameOver),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        gameController.game.bird.reset();
                        gameController.game.overlays.add(MainMenuScreen.id);
                      },
                      icon: Icon(
                        Icons.home_rounded,
                        color: Colors.amber[600],
                      )),
                  ElevatedButton(
                    onPressed: onRestart,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: const Text(
                      'Restart',
                      style:
                          TextStyle(fontSize: 20, fontFamily: "PixelGameFont"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  void onRestart() {
    gameController.game.bird.reset();
    gameController.game.overlays.remove('gameOver');
    gameController.game.resumeEngine();
  }
}
