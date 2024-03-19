import 'package:flappy_phi/screens/auth/login-view.dart';
import 'package:flappy_phi/screens/auth/signup-view.dart';
import 'package:flappy_phi/screens/game_over_screen.dart';
import 'package:flappy_phi/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static List<String> overlay = ['signup', 'login', 'mainMenu', 'gameOver'];

  static Map<String, Widget Function(BuildContext, dynamic)> route() {
    return {
      'signup': (context, _) => const SignupView(),
      'login': (context, _) => const LoginView(),
      'mainMenu': (context, _) => const MainMenuScreen(),
      'gameOver': (context, _) => const GameOverScreen(),
    };
  }
}
