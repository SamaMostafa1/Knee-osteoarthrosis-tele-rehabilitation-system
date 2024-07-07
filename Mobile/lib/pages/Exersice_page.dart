// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:confetti/confetti.dart';
// import 'package:percent_indicator/percent_indicator.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const ExercisePage(),
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//     );
//   }
// }
//
// class ExercisePage extends StatefulWidget {
//   const ExercisePage({super.key});
//
//   @override
//   _ExercisePageState createState() => _ExercisePageState();
// }
//
// class _ExercisePageState extends State<ExercisePage> {
//   double angle = 0;
//   int score = 0;
//   static const maxScore = 2;
//   final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));
//
//   @override
//   void initState() {
//     super.initState();
//     FirebaseDatabase.instance.reference().child('angles').onValue.listen((event) {
//       if (event.snapshot.value != null) {
//         setState(() {
//           angle = double.tryParse(event.snapshot.value.toString()) ?? 0;
//           if (angle == 90) {
//             score++;
//             if (score == maxScore) {
//               _confettiController.play();
//               score = 0;
//             }
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _confettiController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double progress = (score / maxScore).clamp(0.0, 1.0);
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Exercise Page'),
//         centerTitle: true,
//       ),
//       body: OrientationBuilder(
//         builder: (context, orientation) {
//           double gifHeight = orientation == Orientation.portrait ? height * 0.3 : height * 0.5;
//           double gifWidth = orientation == Orientation.portrait ? width  : width * 0.4;
//
//           return Stack(
//             children: [
//               Positioned(
//                 height: gifHeight,
//                 width: gifWidth,
//                 top: 10,
//                 left: (width - gifWidth) / 9,
//                 child: Image.asset(
//                   'assets/exrcise.gif',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               RotatingLeg(angle: angle, rotationOrigin: const Offset(10, -20)),
//               Positioned(
//                 bottom: 60,
//                 left: 30,
//                 child: Text(
//                   'Score: $score',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: ConfettiWidget(
//                   confettiController: _confettiController,
//                   emissionFrequency: 1,
//                   numberOfParticles: 20,
//                   blastDirection: pi / 2,
//                   blastDirectionality: BlastDirectionality.explosive,
//                   shouldLoop: false,
//                   gravity: 0.1,
//                   colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple],
//                 ),
//               ),
//               Positioned(
//                 bottom: 20,
//                 left: 20,
//                 right: 20,
//                 child: Column(
//                   children: [
//                     LinearPercentIndicator(
//                       barRadius: const Radius.circular(10),
//                       lineHeight: 25.0,
//                       percent: progress,
//                       backgroundColor: Colors.grey[300]!,
//                       progressColor: Colors.green,
//                       center: Text(
//                         '${(progress * 100).toStringAsFixed(0)}%',
//                         style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RotatingLeg extends StatelessWidget {
//   final double angle;
//   final Offset rotationOrigin;
//
//   const RotatingLeg({Key? key, required this.angle, required this.rotationOrigin}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return OrientationBuilder(
//       builder: (context, orientation) => Stack(
//         fit: StackFit.expand,
//         children: [
//           Positioned(
//             height: orientation == Orientation.portrait ? 700 : 75,
//             right: -18,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Transform.rotate(
//                   angle: (-angle) * (pi / 180),
//                   alignment: Alignment.topRight,
//                   origin: Offset(-rotationOrigin.dx, -rotationOrigin.dy),
//                   child: Image.asset('assets/Calf.png'),
//                 ),
//                 Image.asset('assets/Thigh.png'),
//               ],
//             ),
//           ),
//           Positioned(
//             right: orientation == Orientation.portrait ? 65 : 62,
//             top: orientation == Orientation.portrait ? 315 : 3,
//             child: const Icon(Icons.circle, size: 80, color: Colors.black),
//           ),
//           Positioned(
//             right: orientation == Orientation.portrait ? 85 : 82,
//             top: orientation == Orientation.portrait ? 335 : 20,
//             child: Text(
//               '${angle.toStringAsFixed(0)}°',
//               style: const TextStyle(color: Colors.white, fontSize: 25),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  double angle = 0;
  int score = 0;
  static const maxScore = 2;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  RawDatagramSocket? _udpSocket;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    updateRecord("exercise", true);
    _startListeningUDP();


  }


  void updateRecord(String button, bool value) async {
    await supabase.from('Controls').update({button: value}).eq('id', 1);
  }

  void _startListeningUDP() async {
    _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8888);
    _udpSocket!.listen((event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _udpSocket!.receive();
        if (datagram != null) {
          String message = utf8.decode(datagram.data);
          setState(() {
            angle = double.tryParse(message) ?? 0;
            print(angle);
            if (angle == 90) {
              score++;
              if (score == maxScore) {
                _confettiController.play();
                score = 0;
              }
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _udpSocket?.close();
    updateRecord("exercise", false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = (score / maxScore).clamp(0.0, 1.0);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Page'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          double gifHeight = orientation == Orientation.portrait ? height * 0.3 : height * 0.5;
          double gifWidth = orientation == Orientation.portrait ? width  : width * 0.4;

          return Stack(
            children: [
              Positioned(
                height: gifHeight,
                width: gifWidth,
                top: 10,
                left: (width - gifWidth) / 9,
                child: Image.asset(
                  'assets/exrcise.gif',
                  fit: BoxFit.cover,
                ),
              ),
              RotatingLeg(angle: angle, rotationOrigin: const Offset(10, -20)),
              Positioned(
                bottom: 60,
                left: 30,
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  emissionFrequency: 1,
                  numberOfParticles: 20,
                  blastDirection: pi / 2,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  gravity: 0.1,
                  colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    LinearPercentIndicator(
                      barRadius: const Radius.circular(10),
                      lineHeight: 25.0,
                      percent: progress,
                      backgroundColor: Colors.grey[300]!,
                      progressColor: Colors.green,
                      center: Text(
                        '${(progress * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RotatingLeg extends StatelessWidget {
  final double angle;
  final Offset rotationOrigin;

  const RotatingLeg({Key? key, required this.angle, required this.rotationOrigin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            height: orientation == Orientation.portrait ? 700 : 75,
            right: -18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: (-angle) * (pi / 180),
                  alignment: Alignment.topRight,
                  origin: Offset(-rotationOrigin.dx, -rotationOrigin.dy),
                  child: Image.asset('assets/Calf.png'),
                ),
                Image.asset('assets/Thigh.png'),
              ],
            ),
          ),
          Positioned(
            right: orientation == Orientation.portrait ? 65 : 62,
            top: orientation == Orientation.portrait ? 315 : 3,
            child: const Icon(Icons.circle, size: 80, color: Colors.black),
          ),
          Positioned(
            right: orientation == Orientation.portrait ? 85 : 82,
            top: orientation == Orientation.portrait ? 335 : 20,
            child: Text(
              '${angle.toStringAsFixed(0)}°',
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}

