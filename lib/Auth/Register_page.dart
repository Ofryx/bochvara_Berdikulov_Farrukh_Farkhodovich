import 'package:flutter/material.dart';
import 'package:vkr_test/button/my_textfield.dart';
import 'package:vkr_test/button/mybutton.dart';


class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Текст
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  // // Метод регистрации пользователя
  // void signUserUp() async {
  //   // Загрузка
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return const Center(
  //         child: CircularProgressIndicator(),
  //       );
  //     },
  //   );

  //   try {
  //     if (passwordController.text.trim() ==
  //         confirmpasswordController.text.trim()) {
  //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: emailController.text.trim(),
  //         password: passwordController.text.trim(),
  //       );
  //       // остановка загруз круга
  //       Navigator.pop(context);
  //     } else {
  //       Navigator.pop(context); // остановка загруз круга перед показом ошибки
  //       showErrorDialog('Пароли не совпадают');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     // остановка загруз круга
  //     Navigator.pop(context);
  //     String errorMessage;
  //     if (e.code == 'email-already-in-use') {
  //       errorMessage = 'Эта почта уже используется.';
  //     } else if (e.code == 'invalid-email') {
  //       errorMessage = 'Неправильная почта.';
  //     } else if (e.code == 'weak-password') {
  //       errorMessage = 'Слишком слабый пароль.';
  //     } else {
  //       errorMessage = 'Ошибка: ${e.message}';
  //     }
  //     showErrorDialog(errorMessage);
  //   } catch (e) {
  //     // остановка загруз круга в случае других ошибок
  //     Navigator.pop(context);
  //     showErrorDialog(
  //         'Произошла непредвиденная ошибка. Пожалуйста, попробуйте позже.');
  //   }
  // }

  // void showErrorDialog(String errorMessage) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return CupertinoAlertDialog(
  //         title: Text('Ошибка'),
  //         content: Text(errorMessage),
  //         actions: [
  //           CupertinoDialogAction(
  //             child: Text('OK'),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
                SizedBox(height: 100),
                // Логотип
                Text(
                  "АГМК",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00171F)),
                ),
                // Добро пожаловать
                const Text(
                  "Регистрация",
                  style: TextStyle(color: Color(0xff003459), fontSize: 23),
                ),
                SizedBox(height: 25),
                // Ввод логина
                MyTextField(
                  controller: emailController,
                  hintText: "Ваша почта",
                  obscureText: false,
                ),

                SizedBox(height: 15),
                // Ввод пароля
                MyTextField(
                  controller: passwordController,
                  hintText: "Пароль",
                  obscureText: true,
                ),
                SizedBox(height: 15),
                MyTextField(
                  controller: confirmpasswordController,
                  hintText: "Подтвердить пароль",
                  obscureText: true,
                ),
                SizedBox(height: 30),

                // Кнопка входа)
                MyButton(
                  onTap: () {}, 
                  text: "Регистрация",
                ),
                SizedBox(height: 25),

                // Continue with ..
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xff003459),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Продолжить с",
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color(0xff003459),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Гугл
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    "lib/assets/google.png",
                    height: 50,
                  ),
                ),
                SizedBox(height: 15),

                // Если не зареган
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Уже есть аккаунт?",
                      style: TextStyle(color: Color(0xff00171F)),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Вход",
                        style: TextStyle(
                            color: Colors.indigo, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
