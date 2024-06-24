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
          if (snapshot.hasData) {
            return HomePage();
          }
          // user not logged in
          else {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blue, Colors.black]),
                ),
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isPortrait = constraints.maxWidth < constraints.maxHeight;
                      return Column(
                        mainAxisAlignment: isPortrait ? MainAxisAlignment.center : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: isPortrait ? 30 : 15),
                          ClipOval(
                            child: Image.asset(
                              'assets/Knee.PNG',
                              width: isPortrait ? 500 : 360,
                              height: isPortrait ? 200 : 200,
                            ),
                          ),
                          SizedBox(height: isPortrait ? 100 : 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                },
                                child: Text('Login'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
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
                      );
                    },
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
