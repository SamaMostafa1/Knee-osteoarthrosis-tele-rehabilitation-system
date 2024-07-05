import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/components/my_buttom.dart';
import 'package:modern_login/components/my_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modern_login/components/square_tile.dart';
import 'package:modern_login/pages/Splash.dart';
import 'package:modern_login/pages/main_page.dart';
import 'package:modern_login/services/auth_service.dart';
import 'forget_password.dart';



class LoginPage extends StatefulWidget {
  // final Function()? onTap;
  // LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading circle
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(),));
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      genericErrorMessage(e.code);
    }
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      resizeToAvoidBottomInset: true,
      body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.white54])),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  //logo
                  const Icon(
                    Icons.face_retouching_off_rounded,
                    size: 150,
                  ),
                  const SizedBox(height: 10),
                  //welcome back you been missed

                  const Text(
                    'Welcome back you\'ve been missed',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 25),

                  //username
                  SizedBox(
                    height: 40,width: 350,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0), // Adjust padding as needed
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),       // الشكل وانت مش دايس على تيكست فيلد
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),      // الشكل وانت دايس على تيكست فيلد
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade300,        // لون باك جراوند بتاع تيكست فيلد
                        hintText: 'Username or email',
                        hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                        prefixIcon: Icon(Icons.mail), // Icon for email
                      ),
                      obscureText: false,  // make text not stars
                    ),
                  ),

                  const SizedBox(height: 15),
                  //password
                  SizedBox(
                    height: 40,width: 350,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0), // Adjust padding as needed
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),       // الشكل وانت مش دايس على تيكست فيلد
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),      // الشكل وانت دايس على تيكست فيلد
                          borderSide: BorderSide(color: Colors.grey.shade600),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade300,        // لون باك جراوند بتاع تيكست فيلد
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                        prefixIcon: Icon(Icons.lock), // Icon for email
                      ),
                      obscureText: false,  // make text not stars
                    ),
                  ),
                  const SizedBox(height: 15),

                  //sign in button
                  MyButton(
                    onTap: signUserIn,
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 20),

                  //forgot passowrd

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Text(
                        //   'Forgot your login details?',
                        //   style: TextStyle(color: Colors.black, fontSize: 15),
                        // ),
                        const SizedBox(width: 10), // Add some space between texts
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            // Navigate to the page where users can reset their password
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 250,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
