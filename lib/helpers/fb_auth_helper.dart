import 'dart:developer';
import 'package:fb_revision/headers.dart';

class FbAuthHelper {
  FbAuthHelper._();

  static final FbAuthHelper fbAuthHelper = FbAuthHelper._();

  Logger logger = Logger();
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();

      log("EMAIL: ${userCredential.user!.email.runtimeType}");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'operation-not-allowed':
          logger.e("Option not enabled !!");
          break;
        case 'admin-restricted-operation':
          logger.t("TRACE: admin-restricted-operation");
        default:
          logger.w("EXCEPTION: ${e.code}");
      }
    } catch (e) {
      logger.i("EXC: $e");
    }
  }

  registerUser({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      logger.i("Email: ${userCredential.user!.email}");

      return userCredential.user;
    } catch (e) {
      logger.w("EXC: $e");
    }
  }

  signInWithEmailPassword({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      logger.i("Email: ${userCredential.user!.email}");

      return userCredential.user;
    } catch (e) {
      logger.w("EXC: $e");
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      GoogleSignInAuthentication authentication = await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      logger.i("G EMAIL: ${userCredential.user!.email}\nName: ${userCredential.user!.displayName}");

      return userCredential.user;
    } catch (e) {
      logger.w("ESC: $e");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();

    log("Signed OUT !!");
  }
}
