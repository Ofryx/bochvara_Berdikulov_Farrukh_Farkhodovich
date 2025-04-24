import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vkr_test/home_page.dart';
import 'package:vkr_test/settings/firebase_options.dart';
import 'package:vkr_test/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ВКР Бердикулов Ф.Ф.',
      home: HomePage(),//SplashScreen(title: 'Flutter Demo Home Page')
    );
  }
}
