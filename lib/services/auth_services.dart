import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static AuthService authService = AuthService._();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> registerNewUSer(
      {required String password, required String email}) async {
    String msg;
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      msg = "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        msg = msg = "password is week 🔒";
      } else if (e.code == 'email-already-in-use') {
        msg = "email already exits...";
      } else if (e.code == 'operation-not-allowed') {
        msg = "operation not allowed...";
      } else {
        msg = e.code;
      }
    }
    return msg;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String msg;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      msg = 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        msg = e.code;
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        msg = e.code;
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      } else {
        msg = e.code;
      }
    }
    return msg;
  }

  Future<String> loginWithGoogle() async {
    String msg;
    try {
      GoogleSignInAccount? googleUsers = await googleSignIn.signIn();
      if (googleUsers != null) {
        //google id popup
        GoogleSignInAuthentication googleAuth =
            await googleUsers.authentication;
        var credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        msg = 'success';
      } else {
        msg = 'failed';
      }
    } on FirebaseAuthException catch (e) {
      msg = e.code;
    }
    return msg;
  }

  //get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  //todo logout method

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }
}
