import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modern_login/pages/login_page.dart';
import 'package:modern_login/pages/register_page.dart';

import 'home_page.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user logged in
          if(snapshot.hasData){
            return HomePage();
          }
          //user not logged in
          else{
            return Scaffold(
                body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.black])),
                  child: SafeArea(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 150),
                        // Add your image here
                        ClipOval(
                          child: Image.asset(
                            'assets/Knee.PNG',
                          ),
                        ),
                        // SizedBox(height: 20), // Optional spacing
                        // Add other widgets below the image if needed
                        SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle login button press
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()),
                                );
                              },
                              child: Text('Login'),
                            ),
                            SizedBox(width: 10), // Adjust the width according to your preference
                            ElevatedButton(
                              onPressed: () {
                                // Handle register button press
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()),
                                );
                              },
                              child: Text('Register'),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),


                      ],
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
