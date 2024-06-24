import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
//import 'package:flutter/services.dart';

class SeverityPage extends StatefulWidget {
  const SeverityPage({super.key});

  @override
  State<SeverityPage> createState() => _SeverityPageState();
}

class CircularBuffer<T> {
  final int capacity;
  List<T> _buffer;

  CircularBuffer(this.capacity) : _buffer = [];

  void add(T element) {
    if (_buffer.length == capacity) {
      _buffer.removeAt(0); // Remove the first element when the buffer is full
    }
    _buffer.add(element); // Add the new element
  }

  List<T> get buffer =>
      List.unmodifiable(_buffer); // Return an unmodifiable view of the buffer

  @override
  String toString() => _buffer.toString();
}

class _SeverityPageState extends State<SeverityPage> {
  var width, height;
  var buffer = CircularBuffer<int>(5);

  late VideoPlayerController _controller;

  RawDatagramSocket? udpSocket;
  String? data;

  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    buffer.add(10);
    buffer.add(20);
    //setupUDP();
  }

  void setupUDP() async {
    udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210);
    udpSocket!.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram datagram = udpSocket!.receive()!;
        if (datagram != null) {
          setState(() {
            data = String.fromCharCodes(datagram.data);
          });
          // String message = String.fromCharCodes(datagram.data);
          // print('Received message: $message');
        }
      }
    });
  }

  @override
  void dispose() {
    udpSocket?.close();
    super.dispose();
  }

  List<Step> steps() => [
        Step(
          title: Text('Calibration'),
          content: Column(
            children: [
              Text('Received data: $buffer'),
              Text(
                  "Here we are going to calibrate the device during standing and sitting before using it."),
              Text(
                  "Please wear the device as previously mentioned in the instructions."),
              Text("Second: "),
              Text(
                  "Second: Please wear the device as previously mentioned in the instructions."),
            ],
          ),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Protocol'),
          content: Column(),
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Third'),
          content: Column(),
          isActive: currentStep >= 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Severity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary:
                Colors.blue.shade900, // This will change the active step color
            //secondary: Colors.green, // This will change the text color
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: Stepper(
            type: StepperType.horizontal,
            physics: ClampingScrollPhysics(),
            steps: steps(),
            currentStep: currentStep,
            onStepContinue: () {
              if (isLastStep) {
              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepCancel:
                isFirstStep ? null : () => setState(() => currentStep -= 1),
            onStepTapped: (step) => setState(() => currentStep = step),
            controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(isLastStep ? 'Confirm' : 'Next'),
                        onPressed: details.onStepContinue,
                      ),
                    ),
                    if (!isFirstStep) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isFirstStep ? null : details.onStepCancel,
                          child: const Text('Back'),
                        ),
                      ),
                    ],
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

void main() => runApp(const VideoApp());

/// Stateful widget to fetch and then display video content.
class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
