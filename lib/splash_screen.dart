import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vkr_test/Auth/Login_page.dart';

class SplashScreen extends StatefulWidget {
  final String title;
  SplashScreen({super.key, required this.title});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage(onTap: () {  },)));  // LoginPage(onTap: () {  },)
          });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Чтобы колонка не занимала всю высоту
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Центрируем по горизонтали
          children: [
            Image.asset("lib/assets/Misis_white.png"),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                // "Выпускная квалификационная работа Бердикулов Фаррух Фарходович \nДата: 03.03.25"
                "Работа для конкурса проектных работ имени академика А.А.Бочвара \n \nБердикулов Фаррух \nФарходович",
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}