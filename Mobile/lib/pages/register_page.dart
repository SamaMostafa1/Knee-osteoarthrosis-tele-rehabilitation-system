import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/components/my_buttom.dart';
import 'package:modern_login/components/my_textfield.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modern_login/components/square_tile.dart';

import '../services/auth_service.dart';
import 'Splash.dart';

class RegisterPage extends StatefulWidget {
  // final Function()? onTap;
  // RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // check if both password and confirm pasword is same
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        //show error password dont match
        genericErrorMessage("Password don't match!");
      }

      //pop the loading circle
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Splash(),));
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

      resizeToAvoidBottomInset: true,
      body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.black])),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  //logo
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  //welcome back you been missed

                  const SizedBox(height: 25),

                  //username
                  SizedBox(
                    height: 40,width: 350,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 15.0), // Adjust padding as needed
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80.0),       // الشكل وانت مش دايس على تيكست فيلد نن
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
                      obscureText: true,  // make text not stars
                    ),
                  ),
                  const SizedBox(height: 15),



                  SizedBox(
                    height: 40,width: 350,
                    child: TextField(
                      controller: confirmPasswordController,
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
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                        prefixIcon: Icon(Icons.lock), // Icon for email
                      ),
                      obscureText: true,  // make text not stars
                    ),
                  ),

                  const SizedBox(height: 15),

                  //sign in button
                  MyButton(
                    onTap: signUserUp,
                    text: 'Sign Up',
                  ),
                  const SizedBox(height: 20),

                  // continue with
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 8, right: 8),
                  //         child: Text(
                  //           'OR',
                  //           style: TextStyle(color: Colors.black),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Divider(
                  //           thickness: 0.5,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 500),

                  //google + apple button

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     //google buttom
                  //     SquareTile(
                  //       onTap: () => AuthService().signInWithGoogle(),
                  //       imagePath: 'lib/icons/google.svg',
                  //       height: 70,
                  //     ),
                  //
                  //     SizedBox(width: 20),
                  //     // apple buttom
                  //     SquareTile(
                  //       onTap: () {},
                  //       imagePath: 'lib/icons/apple.svg',
                  //       height: 70,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 100,
                  // ),

                  // not a memeber ? register now

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Already have an account? ',
                  //       style: TextStyle(color: Colors.black, fontSize: 12),
                  //     ),
                  //     GestureDetector(
                  //       // onTap: widget.onTap,
                  //       child: Text(
                  //         'Login now',
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 14),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
