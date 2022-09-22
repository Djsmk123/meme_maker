import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meme_maker/providers/drag_provider.dart';
import 'package:meme_maker/providers/login_signup_provider.dart';
import 'package:meme_maker/providers/template_provider.dart';
import 'package:meme_maker/providers/text_field_error_provider.dart';
import 'package:meme_maker/providers/text_provider.dart';
import 'package:meme_maker/screens/login_signup_screen.dart';
import 'package:meme_maker/screens/meme_template_selector.dart';
import 'package:meme_maker/services/authencation_service.dart';
import 'package:provider/provider.dart';

import 'package:meme_maker/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Authentication.listenAuth();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextProvider()),
        ChangeNotifierProvider(create: (_) => DragProvider()),
        ChangeNotifierProvider(create: (_) => TemplateProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TextFieldErrorProvider()),
      ],
      builder: (context, widget) {
        User? user = Authentication.user;
        return MaterialApp(
            theme: ThemeData(
                useMaterial3: true, scaffoldBackgroundColor: Colors.white),
            debugShowCheckedModeBanner: false,
            home: user != null
                ? const TemplateSelectorScreen()
                : const LoginSignupScreen());
      },
    );
  }
}
