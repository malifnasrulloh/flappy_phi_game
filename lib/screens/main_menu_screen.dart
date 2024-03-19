import 'package:flappy_phi/controllers/auth_controller.dart';
import 'package:flappy_phi/controllers/firebase/account_controller.dart';
import 'package:flappy_phi/controllers/firebase/firestore_controller.dart';
import 'package:flappy_phi/controllers/game_controller.dart';
import 'package:flappy_phi/controllers/utils.dart';
import 'package:flappy_phi/game/assets.dart';
import 'package:flappy_phi/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MainMenuScreen extends StatefulWidget {
  static const String id = 'mainMenu';
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    double figmaWidth = 844;
    double fem = MediaQuery.of(context).size.width / figmaWidth;

    gameController.game.pauseEngine();

    return GetMaterialApp(
      color: Colors.transparent,
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          GestureDetector(
            onTap: () {
              gameController.game.overlays.removeAll(Routes.overlay);
              gameController.game.resumeEngine();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.menu),
                  fit: BoxFit.cover,
                ),
              ),
              child: Image.asset(Assets.message),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20 * fem),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton.filled(
                    onPressed: () {
                      AuthController.setInitialController();
                      Get.defaultDialog(
                          title: "Profile",
                          content: Column(
                            children: [
                              profileInput(fem, AuthController.nameController,
                                  'Name', const Icon(Icons.person), false),
                              profileInput(
                                  fem,
                                  AuthController.emailController,
                                  'Email',
                                  const Icon(Icons.email_rounded),
                                  true),
                              profileInput(fem, AuthController.uidController,
                                  'UID', const Icon(Icons.key_rounded), true),
                            ],
                          ),
                          onCancel: AuthController.setInitialController,
                          onConfirm: () async {
                            addLoadAnimation(saveToCurrentData());
                            setState(() {});
                            Get.back();
                            AuthController.setInitialController();
                          },
                          textConfirm: "SAVEEEEEE");
                    },
                    icon: const Icon(Icons.person)),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      width: 406 * fem,
                      height: 84 * fem,
                      alignment: Alignment.centerRight,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(127, 192, 199, 209)),
                      padding: EdgeInsets.all(24 * fem),
                      child: Text(
                          "${(AccountController.currentUserData['high_score']) == null ? 0 : AccountController.currentUserData['high_score']}",
                          style: TextStyle(
                            fontFamily: "Game",
                            fontSize: 48 * fem,
                            letterSpacing: 10 * fem,
                          )),
                    ),
                    FilledButton(
                      onPressed: () async {
                        await FirestoreController.getAllData();
                        Get.defaultDialog(
                            title: "LeaderBoard",
                            content: SizedBox(
                              width: 400 * fem,
                              height: 700 * fem,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Container(width: 20 * fem);
                                },
                                itemCount: FirestoreController.allData.length,
                                itemBuilder: (context, index) {
                                  var isCurrentUser = FirestoreController
                                          .allData[index]['uid'] ==
                                      AccountController.currentUser.uid;
                                  var name = isCurrentUser
                                      ? FirestoreController.allData[index]
                                              ['name'] +
                                          " (You)"
                                      : FirestoreController.allData[index]
                                          ['name'];
                                  var color = isCurrentUser
                                      ? Colors.green[400]
                                      : Colors.black;
                                  return TextField(
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: color),
                                    controller: TextEditingController(
                                        text: name == null || name == ""
                                            ? "noname"
                                            : name),
                                    decoration: InputDecoration(
                                        prefix: Text((index + 1).toString(),
                                            style: SafeGoogleFont(
                                              "Poppins",
                                              fontSize: 23 * fem,
                                              fontWeight: FontWeight.w500,
                                              color: color,
                                            )),
                                        suffix: Text(
                                            FirestoreController.allData[index]
                                                    ['high_score']
                                                .toString(),
                                            style: SafeGoogleFont(
                                              "Poppins",
                                              fontSize: 23 * fem,
                                              fontWeight: FontWeight.w500,
                                              color: color,
                                            ))),
                                  );
                                },
                              ),
                            ));
                      },
                      style: FilledButton.styleFrom(
                          padding: EdgeInsets.all(5 * fem),
                          backgroundColor: Colors.green[300],
                          fixedSize: Size(112 * fem, 112 * fem),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28 * fem),
                              side: const BorderSide(color: Colors.white))),
                      child: Image.asset(
                        "assets/images/crown_icon.png",
                      ),
                    )
                  ],
                ),
                IconButton.filled(
                    onPressed: () {
                      AccountController.logout().then((value) async {
                        if (value) {
                          AuthController.emailField.value.text = "";
                          AuthController.passwordField.value.text = "";
                          gameController.game.overlays
                              .remove(MainMenuScreen.id);
                          gameController.game.overlays.add("signup");
                          gameController.game.pauseEngine();
                        }
                      });
                    },
                    icon: const Icon(Icons.output_rounded))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    FirestoreController.storeData(AccountController.currentUser.uid, {
      "name": AccountController.currentUser.displayName ?? ""
    }).whenComplete(() async {
      AccountController.currentUserData =
          await AccountController.getCurrentUserData;
      if (AccountController.currentUserData['high_score'] == null) {
        await FirestoreController.storeData(
            AccountController.currentUser.uid, {"high_score": 0});
        setState(() {});
      }
      print(AccountController.currentUser);
      setState(() {});
    });
    AuthController.setInitialController();

    super.initState();
  }

  Container profileInput(double fem, TextEditingController controller,
      String title, Icon icon, bool readonly) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10 * fem),
      child: TextField(
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: controller.text));
        },
        readOnly: readonly,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
            enabled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.5 * fem)),
            hintText: title,
            suffixIcon: IconButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: controller.text));
                },
                icon: icon),
            hintStyle: SafeGoogleFont("Poppins",
                fontSize: 23 * fem, fontWeight: FontWeight.w500),
            labelStyle: SafeGoogleFont("Poppins",
                fontSize: 23 * fem, fontWeight: FontWeight.w500),
            labelText: title,
            floatingLabelStyle: SafeGoogleFont("Poppins",
                fontSize: 33 * fem, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Future<void> saveToCurrentData() async {
    await AccountController.currentUser
        .updateDisplayName(AuthController.nameController.text);
    await FirestoreController.storeData(AccountController.currentUser.uid,
        {"name": AccountController.currentUser.displayName});
    setState(() {});
  }

  FutureBuilder<void> addLoadAnimation(Future<void> func) {
    return FutureBuilder(
      future: func,
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
