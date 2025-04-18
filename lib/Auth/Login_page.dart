import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkr_test/button/my_textfield.dart';
import 'package:vkr_test/button/mybutton.dart';
import 'package:vkr_test/home_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Текст
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in
  void signIn() async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Remove leading and trailing spaces from email input
    String email = emailController.text.trim();

    // Add the "@gmail.com" domain to the entered ID
    email = "$email@gmail.com";

    // Try signing in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      // Pop loading circle
      if (context.mounted) Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Display error message
      displayMessage(e.code);
    }
  }

  // Display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 120),
                // Логотип
                Center(
                  child: Text(
                    "Бердикулов Фаррух",
                    
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00171F),
                    ),
                  ),
                ),
                // Добро пожаловать
                const Text(
                  "Вход",
                  style: TextStyle(color: Color(0xff003459), fontSize: 23),
                ),
                SizedBox(height: 25),
                // Ввод логина
                MyTextField(
                  controller: emailController,
                  hintText: "Ваш ID",
                  obscureText: false,
                ),

                SizedBox(height: 15),
                // Ввод пароля
                MyTextField(
                  controller: passwordController,
                  hintText: "Пароль",
                  obscureText: true,
                ),
                SizedBox(height: 10),
                // Забыл пароль
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Забыли пароль?",
                          style: TextStyle(color: Color(0xff003459)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                MyButton(onTap: signIn, text: 'Войти'),
                SizedBox(height: 25),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Color(0xff003459),
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10),
                //         child: Text(
                //           "Продолжить с",
                //           style: TextStyle(color: Color(0xff003459)),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Color(0xff003459),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // SizedBox(height: 25),
                // Container(
                //   padding: EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.black),
                //     borderRadius: BorderRadius.circular(15),
                //     color: Colors.white,
                //   ),
                //   child: Image.asset("lib/assets/google.png", height: 50),
                // ),

                // SizedBox(height: 25),

                // Если не зареган
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Cвязаться с руководством",
                      style: TextStyle(color: Color(0xff00171F)),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "ТЕХ.ПОДДЕРЖКА",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
