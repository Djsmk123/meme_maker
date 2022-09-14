import 'package:flutter/material.dart';

class TextFieldErrorProvider with ChangeNotifier {
  Map formsError = {};
  getFormError(key) {
    if (formsError.containsKey(key)) {
      return formsError[key];
    } else {
      return "";
    }
  }

  setFormError(key, error) async {
    formsError[key] = error;
    await Future.delayed(const Duration(milliseconds: 5));
    notifyListeners();
  }

  resetErrors() {
    formsError = {};
  }

  hideFormErrors(key) {
    formsError[key] = '';
    notifyListeners();
  }
}