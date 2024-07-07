import 'package:flutter/material.dart';
import 'package:modern_login/pages/Splash.dart';
import 'package:modern_login/pages/auth_page.dart';
import 'package:modern_login/pages/instruction_page.dart';
import 'package:modern_login/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modern_login/pages/main_page.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fmszngwfmhnbbwyngztc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZtc3puZ3dmbWhuYmJ3eW5nenRjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg4ODI4NDMsImV4cCI6MjAzNDQ1ODg0M30.0YuDgAcCgYtg3aQwpMpjxphTc-AqtwKqtt_VT8qiycc',
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
    // return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      // home: MainPage(),
      // home: instruction(),
      // home: VideoApp(),
    );
  }
}