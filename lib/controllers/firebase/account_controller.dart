import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_phi/controllers/auth_controller.dart';
import 'package:flappy_phi/controllers/firebase/firestore_controller.dart';
import 'package:flappy_phi/game/flappy_phi_game.dart';

class AccountController {
  static late final FlappyPhiGame game;

  static final authInstance = FirebaseAuth.instance;
  static Stream<User?> get authStatus => authInstance.authStateChanges();

  static Map<String, dynamic> currentUserData = {};
  static Future<Map<String, dynamic>> get getCurrentUserData async =>
      (await FirestoreController.db
              .collection("userData")
              .doc(AccountController.currentUser.uid)
              .get())
          .data()!;

  static User get currentUser => AccountController.authInstance.currentUser!;

  static Future<bool> loginWithEmailAndPassword() async {
    try {
      await authInstance.signInWithEmailAndPassword(
          email: AuthController.emailField.value.text,
          password: AuthController.passwordField.value.text);
      return true;
    } on FirebaseAuthException catch (e) {
      AuthController.warningException.add(e.message);
      return false;
    } catch (e) {
      AuthController.warningException.add(e.toString());
      return false;
    }
  }

  static Future<bool> signupWithEmailAndPassword() async {
    try {
      await authInstance.createUserWithEmailAndPassword(
        email: AuthController.emailField.value.text,
        password: AuthController.passwordField.value.text,
      );
      await authInstance.currentUser!.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      AuthController.warningException.add(e.message);
      return false;
    } catch (e) {
      AuthController.warningException.add(e);
      return false;
    }
  }

  static Future<bool> logout() async {
    await authInstance.signOut();
    return true;
  }

  static Future<bool> loginWithGoogle() async {
    await authInstance.signInWithProvider(GoogleAuthProvider());
    if (authInstance.currentUser == null) {
      return false;
    }
    currentUserData = await getCurrentUserData;
    return true;
  }
}
