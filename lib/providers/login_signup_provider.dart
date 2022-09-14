import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier{
  User? user;
  get getUser=>user;
  bool isLoading=false;
  get loadingStatus=>isLoading;
  bool isPasswordResetRequest=false;

  get passwordResetRequest=>isPasswordResetRequest;
  set setPasswordResetRequest(bool value){
    isPasswordResetRequest=value;
    notifyListeners();
  }
  setUser(){
    user=FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
  set setLoading(value){
    isLoading=!isLoading;
    notifyListeners();
  }

}