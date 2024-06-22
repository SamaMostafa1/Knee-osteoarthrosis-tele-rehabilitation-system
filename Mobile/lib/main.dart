import 'package:flutter/material.dart';
import 'package:modern_login/pages/Splash.dart';
import 'package:modern_login/pages/auth_page.dart';
import 'package:modern_login/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modern_login/pages/main_page.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    // return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      // home: MainPage(),
    );
  }
}

