import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Database
import 'package:confetti/confetti.dart';

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
  int score = 0; // Initialize score counter
  static const maxScore = 2; // Maximum score for full progress
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));

  @override
  void initState() {
    super.initState();

    // Listen to changes in Firebase Realtime Database
    FirebaseDatabase.instance
        .reference()
        .child('angles')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          angle = double.tryParse(event.snapshot.value.toString()) ??
              0; // Convert to double safely
          if (angle == 90) {
            score++; // Increment score if angle is 90
            if (score == maxScore) {
              _confettiController.play();
              score=0;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress =
    (score / maxScore).clamp(0.0, 1.0); // Calculate progress value

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Page'),
      ),
      body: Stack(
        children: [
          RotatingLeg(angle: angle, rotationOrigin: Offset(10, -20)),
          Positioned(
            top: 20,
            left: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Text(
                  'Score: $score',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              emissionFrequency:1 ,
              numberOfParticles: 20,
              blastDirection: pi/2 , // upwards
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              gravity: 0.1,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple
              ], // manually specify the colors to be used
            ),
          ),
        ],
      ),
    );
  }
}

class RotatingLeg extends StatelessWidget {
  final double angle; // angle in degrees
  final Offset rotationOrigin; // specific point to rotate around

  const RotatingLeg(
      {Key? key, required this.angle, required this.rotationOrigin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(height: 700,right: -18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: (-angle) *
                    (3.14159265359 / 180), // Convert degrees to radians
                alignment: Alignment.topRight,
                origin: Offset(-rotationOrigin.dx,
                    -rotationOrigin.dy), // Adjust rotation origin
                child: Image.asset('assets/Calf.png'),
              ),
              Image.asset('assets/Thigh.png'),
            ],
          ),
        ),
        Positioned(
          right: 65,
          top: 315,
          child: const Icon(Icons.circle, size: 80),
        ),
        Positioned(
          right: 85,
          top: 335,
          child: Text(angle.toStringAsFixed(0) + "°",
              style: const TextStyle(color: Colors.white, fontSize: 25)),
        ),
      ],
    );
  }
}
