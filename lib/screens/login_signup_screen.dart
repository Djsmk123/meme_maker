// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meme_maker/constant.dart';
import 'package:meme_maker/models/user_model.dart';
import 'package:meme_maker/providers/login_signup_provider.dart';
import 'package:meme_maker/screens/meme_template_selector.dart';
import 'package:meme_maker/services/authencation_service.dart';
import 'package:provider/provider.dart';

import '../components/custom_text_input_field.dart';
import '../providers/text_field_error_provider.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoginModel model = LoginModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).isLoading = false;
    Provider.of<AuthProvider>(context, listen: false).isPasswordResetRequest =
        false;
  }

  @override
  Widget build(BuildContext context) {
    bool isForgotPassword =
        Provider.of<AuthProvider>(context).passwordResetRequest;
    bool isLoading = Provider.of<AuthProvider>(context).loadingStatus;
    return WillPopScope(
      onWillPop: () async {
        if (isForgotPassword) {
          Provider.of<AuthProvider>(context, listen: false)
              .setPasswordResetRequest = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Login / Signup",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Image.asset(
                        "assets/images/we_go_again.png",
                        height: 200,
                      )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextInputContainer(
                        errorKey: 'email',
                        isEnable: !isLoading,
                        keyboardTyp: TextInputType.emailAddress,
                        valueChanged: (String value) {
                          model.email = value;
                        },
                        valid: (String? value) {
                          String? message;
                          if (value!.isEmpty) {
                            message = "Email can't be empty.";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            message = "Email address is not valid.";
                          }
                          if (message != null) {
                            Provider.of<TextFieldErrorProvider>(context,
                                    listen: false)
                                .setFormError('email', message);
                          }
                          return message;
                        },
                        label: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!isForgotPassword)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextInputContainer(
                          isPassword: true,
                          errorKey: 'pass',
                          isEnable: !isLoading,
                          keyboardTyp: TextInputType.visiblePassword,
                          valueChanged: (String value) {
                            model.pass = value;
                          },
                          valid: (String? value) {
                            String? message;
                            if (value!.isEmpty) {
                              message = "Password can't be empty.";
                            }
                            if (message != null) {
                              Provider.of<TextFieldErrorProvider>(context,
                                      listen: false)
                                  .setFormError('pass', message);
                            }
                            return message;
                          },
                          label: 'Password',
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!isForgotPassword)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .setPasswordResetRequest = true;
                            },
                            child: Text(
                              "Forgot Password?",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          if (!isForgotPassword) {
                            Provider.of<AuthProvider>(context, listen: false)
                                .setLoading = true;
                            try {
                              await Authentication.login(
                                  email: model.email!, password: model.pass!);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const TemplateSelectorScreen()));
                            } on Exception catch (e) {
                              debugPrint('error $e');
                              if (e.toString() ==
                                  "Exception: User with this email doesn't exist.") {
                                try {
                                  await Authentication.signUp(
                                      email: model.email!,
                                      password: model.pass!);
                                  await Authentication.createProfile(UserModel.fromJson({
                                    "name":"No_Name@${Random().nextInt(6898989)}",
                                    "img":null,
                                  }));
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              const TemplateSelectorScreen()));
                                } catch (e) {
                                  Fluttertoast.showToast(msg: e.toString());
                                }
                              } else {
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            }
                            Provider.of<AuthProvider>(context, listen: false)
                                .setLoading = false;
                          } else {
                            Provider.of<AuthProvider>(context, listen: false)
                                .setLoading = true;
                            try {
                              await Authentication.resetPassword(
                                  email: model.email!);
                              Fluttertoast.showToast(
                                  msg:
                                      "Link has been sent to your email address");
                              Provider.of<AuthProvider>(context, listen: false)
                                  .setPasswordResetRequest = false;
                            } catch (e) {
                              debugPrint(e.toString());
                              Fluttertoast.showToast(
                                  msg: "Something went wrong");
                            }
                            Provider.of<AuthProvider>(context, listen: false)
                                .setLoading = false;
                          }
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: !isLoading
                            ? Text(
                                !isForgotPassword
                                    ? "Continue"
                                    : "Forgot Password",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                    if (!isForgotPassword)
                      GestureDetector(
                        onTap: () async {
                          try {
                            Provider.of<AuthProvider>(context, listen: false)
                                .setLoading = false;
                            await FirebaseAuth.instance.signInAnonymously();
                            Provider.of<AuthProvider>(context, listen: false)
                                .setLoading = false;
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        const TemplateSelectorScreen()));
                          } catch (e) {
                            Fluttertoast.showToast(msg: "Something went wrong");
                          }
                          Provider.of<AuthProvider>(context, listen: false)
                              .setLoading = false;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(16)),
                          child: !isLoading
                              ? const Text(
                                  "Skip",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginModel {
  String? email;
  String? pass;
}
