import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flappy_phi/controllers/firebase/account_controller.dart';
import 'package:flappy_phi/controllers/game_controller.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';
import 'package:flappy_phi/routes.dart';
import 'package:flappy_phi/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(gameController(), permanent: true);
  runApp(StreamBuilder<User?>(
      stream: AccountController.authStatus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return GameWidget<FlappyPhiGame>(
            game: gameController.game,
            initialActiveOverlays: [
              snapshot.data != null && snapshot.data!.emailVerified == true
                  ? MainMenuScreen.id
                  : 'signup'
            ],
            overlayBuilderMap: Routes.route(),
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }));
}
