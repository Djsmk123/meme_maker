import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class Authentication {

  static Future signUp({required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    var errorMessage = "";
    var user = await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user)  {
      if (user.user != null) {
        return 0;
      }
    }).catchError((error) {
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Anonymous accounts are not enabled";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = ("Your password is too weak");
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = ("Your email is invalid");
          break;
        case "email-already-in-use":
          errorMessage = ("Email is already in use on different account");
          break;
        case "ERROR_INVALID_CREDENTIAL":
          errorMessage = ("Your email is invalid");
          break;
        default:
          errorMessage = ("Something went wrong,try again.");
          break;
      }
    });
    if (errorMessage.isNotEmpty || user == null) {
      throw Exception(errorMessage);
    }
  }

  static Future login({required String email, required String password}) async {
    final auth = FirebaseAuth.instance;
    String? errorMessage;
    try{
    await auth.signInWithEmailAndPassword(email: email, password: password).then((value) =>value.user);
    }on FirebaseAuthException catch(error){
      log('error$error');

      switch (error.code.toString().toLowerCase()) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Something went wrong";
      }
    }

    if (errorMessage!=null) {

        log("error$errorMessage");

      throw Exception(errorMessage);
    }
    return null;
  }


 static Future resetPassword({required String email}) async {
   final auth = FirebaseAuth.instance;
    var errorMessage = "";
    await auth.sendPasswordResetEmail(email: email).then((user) {
      return 0;
    }).catchError((error) {
      switch (error.code.toString().toLowerCase()) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "Something went wrong";
      }
    });
    throw Exception(errorMessage);
  }

  static Future logOut() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut().catchError((error) {
      throw Exception("Something went wrong");
    });
  }
  static User? user;
  static listenAuth(){
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if(event!=null && !event.isAnonymous)
      {
        user=event;
      }
    });
  }

}