import 'package:flutter/material.dart';
import 'package:meme_maker/providers/drag_provider.dart';
import 'package:meme_maker/providers/template_provider.dart';
import 'package:meme_maker/providers/text_provider.dart';
import 'package:meme_maker/screens/meme_template_selector.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TextProvider()),
        ChangeNotifierProvider(create: (_)=>DragProvider()),
        ChangeNotifierProvider(create: (_)=>TemplateProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true
        ),
        debugShowCheckedModeBanner: false,
        home:const TemplateSelectorScreen()
      ),
    );
  }
}

