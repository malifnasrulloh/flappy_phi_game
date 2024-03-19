import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_phi/game/configuration.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';
import 'package:flutter/material.dart';

class Question extends SpriteComponent with HasGameRef<FlappyPhiGame> {
  Question();

  static List soal = [];
  static int answer = 0;
  static int wrongAnswer = 0;
  static int indexAnswer = 0;
  static int indexWrongAnswer = 0;

  static int scaleNum = 1;

  @override
  FutureOr<void> onLoad() async {
    var frameQuestion = await Flame.images.load("frame_soal.png");
    sprite = Sprite(frameQuestion);
    position = Vector2(
        gameRef.size.x / 2 - sprite!.srcSize.x / 2,
        gameRef.size.y / 2 -
            sprite!.srcSize.y / 2 -
            (gameRef.size.y / 2 - Config.groundHeight));
    add(TextComponent(
        text: Question.soal[0],
        position: Vector2(size.x / 2 - x / 3, size.y / 2),
        textRenderer: TextPaint(
            style: const TextStyle(
                fontFamily: "PixelGameFont", fontSize: 24, color: Colors.blue)),
        priority: 1));
    return super.onLoad();
  }

  static void generate() {
    Question.soal = generateSoal();
    Question.answer = soal[1];
    Question.wrongAnswer = genenerateWrongAnswer(answer);
    Question.indexAnswer = Random().nextInt(2);
    Question.indexWrongAnswer = indexAnswer == 0 ? 1 : 0;
  }

  static int genenerateWrongAnswer(int answer) {
    Random rand = Random();
    return rand.nextInt(((answer + 1) / 2).round()) +
        (answer + 1) +
        ((answer + 1) / 2).round();
  }

  static List generateSoal() {
    Random random = Random();

    int num1 = random.nextInt(10 * Question.scaleNum);
    int num2 = random.nextInt(10 * Question.scaleNum);
    List<String> operators = ['*', '+', '-'];
    String operator = operators[random.nextInt(3)];
    int answer = 0;

    String question = '';
    switch (operator) {
      case '*':
        question = '$num1 * $num2';
        answer = num1 * num2;
        break;
      case '+':
        question = '$num1 + $num2';
        answer = num1 + num2;
        break;
      case '-':
        num1 = max(num1, num2);
        num2 = min(num1, num2);
        question = '$num1 - $num2';
        answer = num1 - num2;
        break;
      default:
        break;
    }
    return [question, answer];
  }
}
