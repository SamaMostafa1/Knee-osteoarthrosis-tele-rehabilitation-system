// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   double _opacity = 0.2; // Initial opacity (faded)

//   void _changeOpacity() {
//     setState(() {
//       _opacity = _opacity == 0.2 ? 1.0 : 0.2; // Toggle opacity
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Animated Opacity Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedOpacity(
//               opacity: _opacity,
//               duration: Duration(seconds: 0), // Duration of the fade animation
//               child: Column(
//                 children: [
//                   Image.asset(
//                     'assets/Knee.png',
//                     width: 100,
//                     height: 100,
//                   ),
//                   Text(
//                     'Hello, Flutter!',
//                     style: TextStyle(fontSize: 24, color: Colors.blue),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _changeOpacity,
//               child: Text('Toggle Visibility'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Button Example'),
      ),
      body: Center(
        child: Container(
          width: 50,
          height: 50,
          child: _isDone
              ? Image.asset(
                  'assets/Done.png',
                  //width: width * 0.35,
                  //height: height * 0.15,
                )
              : _isLoading
                  ? CircularProgressIndicator()
                  : IconButton(
                      onPressed: _startProcess,
                      icon: Icon(
                        Icons.play_arrow,
                        size: 50,
                      ),
                    ),
        ),
      ),
    );
  }

  void _startProcess() {
    setState(() {
      _isLoading = true;
    });

    _receiveDataFromUDPServer().then((_) {
      setState(() {
        _isLoading = false;
        _isDone = true;
      });
    });
  }

  Future<void> _receiveDataFromUDPServer() async {
    // Simulate a delay to mimic receiving data from a UDP server
    await Future.delayed(Duration(seconds: 5));

    // For actual UDP server communication, you can use RawDatagramSocket
    // RawDatagramSocket.bind(InternetAddress.anyIPv4, 8080).then((socket) {
    //   socket.listen((event) {
    //     if (event == RawSocketEvent.read) {
    //       Datagram? datagram = socket.receive();
    //       if (datagram != null) {
    //         // Process the received data here
    //         print(String.fromCharCodes(datagram.data));
    //         // If a certain event occurs, you can set _isDone to true
    //         setState(() {
    //           _isDone = true;
    //         });
    //       }
    //     }
    //   });
    // });

    // For now, we simulate the event occurrence by directly setting _isDone to true
    setState(() {
      _isDone = true;
    });
  }
}
