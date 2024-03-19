import 'package:flappy_phi/controllers/auth_controller.dart';
import 'package:flappy_phi/controllers/firebase/account_controller.dart';
import 'package:flappy_phi/controllers/game_controller.dart';
import 'package:flappy_phi/controllers/utils.dart';
import 'package:flappy_phi/routes.dart';
import 'package:flappy_phi/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    double figmaWidth = 816;
    double fem = MediaQuery.of(context).size.width / figmaWidth;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/images/signup_prev_ui.png", width: 404 * fem),
            Text("Login",
                style: SafeGoogleFont("Poppins",
                    fontSize: 65 * fem, fontWeight: FontWeight.w700)),
            Container(
              width: 631 * fem,
              decoration: BoxDecoration(
                  color: const Color(0x000a86ff),
                  borderRadius: BorderRadius.circular(22.5 * fem)),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        if (!value.isEmail) {
                          AuthController.warningEmailField
                              .add("*invalid email format");
                        } else {
                          AuthController.warningEmailField
                              .remove("*invalid email format");
                        }
                        if (value.isEmpty) {
                          AuthController.warningEmailField.add("*required");
                        } else {
                          AuthController.warningEmailField.remove("*required");
                        }
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: AuthController.emailField.value,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.5 * fem)),
                        hintText: "yourmail@gmail.com",
                        suffixIcon: const Icon(Icons.email_rounded),
                        hintStyle: SafeGoogleFont("Poppins",
                            fontSize: 23 * fem, fontWeight: FontWeight.w500),
                        labelStyle: SafeGoogleFont("Poppins",
                            fontSize: 23 * fem, fontWeight: FontWeight.w500),
                        labelText: "Email",
                        floatingLabelStyle: SafeGoogleFont("Poppins",
                            fontSize: 33 * fem, fontWeight: FontWeight.w500)),
                  ),
                  for (int i = 0;
                      i < AuthController.warningEmailField.length;
                      i++)
                    Obx(() => Text(
                        AuthController.warningEmailField.elementAt(i),
                        style: SafeGoogleFont("Poppins",
                            fontSize: 23 * fem,
                            fontWeight: FontWeight.w500,
                            color: Colors.red))),
                ],
              ),
            ),
            Container(
              width: 631 * fem,
              decoration: BoxDecoration(
                  color: const Color(0x000a86ff),
                  borderRadius: BorderRadius.circular(22.5 * fem)),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        if (value.length < 8) {
                          AuthController.warningPasswordField
                              .add("*minimum 8 character");
                        } else {
                          AuthController.warningPasswordField
                              .remove("*minimum 8 character");
                        }
                        if (value.isEmpty) {
                          AuthController.warningPasswordField.add("*required");
                        } else {
                          AuthController.warningPasswordField
                              .remove("*required");
                        }
                      });
                    },
                    controller: AuthController.passwordField.value,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22.5 * fem)),
                        hintText: "Enter Password",
                        suffixIcon: const Icon(Icons.lock_outline_rounded),
                        hintStyle: SafeGoogleFont("Poppins",
                            fontSize: 23 * fem, fontWeight: FontWeight.w500),
                        labelStyle: SafeGoogleFont("Poppins",
                            fontSize: 23 * fem, fontWeight: FontWeight.w500),
                        labelText: "Password",
                        floatingLabelStyle: SafeGoogleFont("Poppins",
                            fontSize: 33 * fem, fontWeight: FontWeight.w500)),
                  ),
                  for (int i = 0;
                      i < AuthController.warningPasswordField.length;
                      i++)
                    Obx(() => Text(
                        AuthController.warningPasswordField.elementAt(i),
                        style: SafeGoogleFont("Poppins",
                            fontSize: 23 * fem,
                            fontWeight: FontWeight.w500,
                            color: Colors.red)))
                ],
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Divider(
                  color: Colors.blueAccent,
                  height: 25 * fem,
                  thickness: 2 * fem,
                  indent: 20 * fem,
                  endIndent: 20 * fem,
                ),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 25 * fem),
                  child: const Text(
                    "Or",
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () async {
                  if (await AccountController.loginWithGoogle() == true) {
                    gameController.game.overlays.remove("login");
                    gameController.game.overlays.add(MainMenuScreen.id);
                    gameController.game.pauseEngine();
                  }
                },
                icon: SvgPicture.asset(
                  "assets/images/icon google.svg",
                  width: 92 * fem,
                )),
            FilledButton(
                style: FilledButton.styleFrom(
                    elevation: 15 * fem,
                    fixedSize: Size(632 * fem, 84 * fem),
                    shadowColor: Colors.lightBlue),
                onPressed: (() async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  AuthController.warningException.clear();
                  if (AuthController.emailField.value.text.isEmail &&
                      AuthController.passwordField.value.text.length >= 8) {
                    if ((await AccountController.loginWithEmailAndPassword()) ==
                            true &&
                        AccountController.currentUser.emailVerified == true) {
                      AuthController.emailField.value.text = "";
                      AuthController.passwordField.value.text = "";
                      gameController.game.overlays.removeAll(Routes.overlay);
                      gameController.game.overlays.add(MainMenuScreen.id);
                      return;
                    }
                    setState(() {
                      AuthController.warningException
                          .addAll(AuthController.warningException.toSet());
                    });
                  }
                }),
                child: Text(
                  "Login",
                  style: SafeGoogleFont("Poppins",
                      fontSize: 23 * fem, color: Colors.white),
                )),
            for (int i = 0;
                AuthController.warningException.isNotEmpty &&
                    i < AuthController.warningException.length;
                i++)
              Obx(() => Text(AuthController.warningException.elementAt(i),
                  style: SafeGoogleFont("Poppins",
                      fontSize: 23 * fem,
                      fontWeight: FontWeight.w500,
                      color: Colors.red))),
            TextButton(
                onPressed: () {
                  gameController.game.overlays.add('signup');
                  gameController.game.pauseEngine();
                },
                child: Text(
                  "doesn't have an account?",
                  style: SafeGoogleFont("Poppins",
                      fontSize: 23 * fem, fontWeight: FontWeight.w500),
                ))
          ],
        ),
      ),
    );
  }
}
