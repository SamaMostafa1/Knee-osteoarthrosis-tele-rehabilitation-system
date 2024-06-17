import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExercisePage(),
    );
  }
}

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  double angle = 0; // Initialize angle

  @override
  void initState() {
    super.initState();
    // Listen to changes in Firebase Realtime Database
    FirebaseDatabase.instance.reference().child('angles').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          angle = double.tryParse(event.snapshot.value.toString()) ?? 0; // Convert to double safely
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Page'),
      ),
      body: Center(
        child: RotatingLeg(angle: angle, rotationOrigin: Offset(18, -30)),
      ),
    );
  }
}

class RotatingLeg extends StatelessWidget {
  final double angle; // angle in degrees
  final Offset rotationOrigin; // specific point to rotate around

  const RotatingLeg({Key? key, required this.angle, required this.rotationOrigin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: (-angle) * (3.14159265359 / 180), // Convert degrees to radians
              alignment: Alignment.topRight,
              origin: Offset(-rotationOrigin.dx, -rotationOrigin.dy), // Adjust rotation origin
              child: Image.asset('assets/Calf.png'),
            ),
            Image.asset('assets/Thigh.png'),
          ],
        ),
        Positioned(
          left: 300,
          bottom: 380,
          child: const Icon(Icons.circle, size: 80),
        ),
        Positioned(
          left: 325,
          bottom: 400,
          child: Text(angle.toStringAsFixed(0) + "°", style: const TextStyle(color: Colors.white, fontSize: 25)),
        )
      ],
    );
  }
}
