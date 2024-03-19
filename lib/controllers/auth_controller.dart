import 'package:flappy_phi/controllers/firebase/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static final emailField = TextEditingController().obs;
  static final passwordField = TextEditingController().obs;
  static final RxSet<dynamic> warningEmailField = <dynamic>{}.obs;
  static final RxSet<dynamic> warningPasswordField = <dynamic>{}.obs;
  static final RxSet<dynamic> warningException = <dynamic>{}.obs;

  //current data
  static final nameController = TextEditingController();
  static final emailController = TextEditingController();
  static final uidController = TextEditingController();

  static void setInitialController() {
    AuthController.nameController.text =
        AccountController.currentUser.displayName == null
            ? ""
            : AccountController.currentUser.displayName!;
    AuthController.uidController.text = AccountController.currentUser.uid;
    AuthController.emailController.text = AccountController.currentUser.email!;
  }
}
