import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      // Remove the first element when the buffer is full
      _buffer.removeAt(0);
    }
    // Add the new element
    _buffer.add(element);
  }

  List<T> get buffer =>
      // Return an unmodifiable view of the buffer
      List.unmodifiable(_buffer);

  @override
  String toString() => _buffer.toString();
}

class _SeverityPageState extends State<SeverityPage> {
  var width, height;
  List buffer = [];
  final int capacity = 5;

  double _opacity_2 = 0.2; // Initial opacity (faded)
  double _opacity_1 = 1; // Initial opacity (faded)
  bool _isLoading_1 = false;
  bool _isLoading_2 = false;
  bool _isDone_1 = false;
  bool _isDone_2 = false;

  late VideoPlayerController _controller;

  RawDatagramSocket? udpSocket;
  String? data;

  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/Protocol.mp4')
      ..initialize().then((_) {});

    buffer.add(10);
    buffer.add(20);
    //setupUDP();
  }

  void add(int element) {
    if (buffer.length == capacity) {
      // Remove the first element when the buffer is full
      buffer.removeAt(0);
    }
    // Add the new element
    buffer.add(element);
  }

  void _changeOpacity(int num) {
    setState(() {
      if (num == 1) {
        _opacity_1 = _opacity_1 != 1.0 ? 1.0 : 0.2; // Toggle opacity
        _opacity_2 = _opacity_2 != 1.0 ? 1.0 : 0.2; // Toggle opacity
      }
      if (num == 2) {
        _opacity_2 = _opacity_2 != 1.0 ? 1.0 : 0.2; // Toggle opacity
      }
    });
  }

  // void setupUDP() async {
  //   udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210);
  //   udpSocket!.listen((RawSocketEvent event) {
  //     if (event == RawSocketEvent.read) {
  //       Datagram datagram = udpSocket!.receive()!;
  //       if (datagram != null) {
  //         setState(() {
  //           data = String.fromCharCodes(datagram.data);
  //         });
  //         // String message = String.fromCharCodes(datagram.data);
  //         // print('Received message: $message');
  //       }
  //     }
  //   });
  // }

  void _startProcess(int num) {
    if (num == 1) {
      setState(() {
        _isLoading_1 = true;
      });
    }
    if (num == 2) {
      setState(() {
        _isLoading_2 = true;
      });
    }

    _receiveDataFromUDPServer(num).then((_) {
      // setState(() {
      //   _isLoading = false;
      //   //_isDone = true;
      // });
    });
  }

  Future<void> _receiveDataFromUDPServer(int num) async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 4210).then((socket) {
      socket.listen((event) {
        if (event == RawSocketEvent.read) {
          Datagram? datagram = socket.receive();
          if (datagram != null) {
            // Process the received data
            ByteData byteData = ByteData.sublistView(datagram.data);
            int receivedInt = byteData.getInt32(0, Endian.big);
            //buffer.add(receivedInt);
            add(receivedInt);

            if (buffer.length == capacity) {
              int sum =
                  buffer[0] + buffer[1] + buffer[2] + buffer[3] + buffer[4];
              int avg = sum ~/ capacity;
              if (num == 1) {
                if (avg > -5 && avg < 10) {
                  //Future.delayed(Duration(seconds: 10));
                  setState(() {
                    _isDone_1 = true;
                    _isLoading_1 = false;
                    _changeOpacity(num);
                    socket.close();
                  });
                }
              }
              if (num == 2) {
                //if (avg > 82 && avg < 95) {
                if (avg > -5 && avg < 10) {
                  //Future.delayed(Duration(seconds: 10));
                  setState(() {
                    _isDone_2 = true;
                    _isLoading_2 = false;
                    _changeOpacity(num);
                    socket.close();
                  });
                }
              }
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    //udpSocket?.close();
    super.dispose();
  }

  List<Step> steps() => [
        Step(
          title: Text('Info'),
          content:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: height * 0.02),
            Text(
              "1- Here we are going to calibrate the device in 2 positions, standing and sitting.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "2- After Calibrating the device we will show you a video explaining our protocol.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "3- Finally, when you are ready you can do the protocol.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: height * 0.05),
            Text(
              "-Please, wear the device and place it as mentioned in the instructions.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
          ]),
          isActive: currentStep >= 0,
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Calib'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text('Received data: $buffer'),
              //SizedBox(height: height * 0.05),
              Text(
                "-Press the start button and don't move.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Text(
                "-Once calibration is done an icon will appear.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(height: height * 0.02),
              AnimatedOpacity(
                opacity: _opacity_1,
                duration: Duration(seconds: 0),
                child: Text(
                  "1- Stand Position:",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                AnimatedOpacity(
                  opacity: _opacity_1,
                  duration: Duration(seconds: 0),
                  child: Image.asset(
                    'assets/stand.png',
                    width: width * 0.35,
                    height: height * 0.15,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: _isDone_1
                      ? Image.asset(
                          'assets/Done.png',
                        )
                      : _isLoading_1
                          ? CircularProgressIndicator()
                          : IconButton(
                              onPressed: () {
                                _startProcess(1);
                              },
                              icon: Icon(Icons.play_arrow),
                              color: Colors.blue[900],
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blue[50])),
                            ),
                ),
              ]),
              SizedBox(height: height * 0.02),
              AnimatedOpacity(
                opacity: _opacity_2,
                duration: Duration(seconds: 0),
                child: Text(
                  "2- Sit Position:",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                AnimatedOpacity(
                  opacity: _opacity_2,
                  duration: Duration(seconds: 0),
                  child: Image.asset(
                    'assets/sit.png',
                    width: width * 0.35,
                    height: height * 0.15,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: _isDone_2
                      ? Image.asset(
                          'assets/Done.png',
                        )
                      : _isLoading_2
                          ? CircularProgressIndicator()
                          : AnimatedOpacity(
                              opacity: _opacity_2,
                              duration: Duration(seconds: 0),
                              child: IconButton(
                                onPressed: () {
                                  if(_isDone_1)
                                  {
                                    _startProcess(2);
                                  }
                                },
                                icon: Icon(Icons.play_arrow),
                                color: Colors.blue[900],
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blue[50])),
                              ),
                            ),
                ),
              ]),
            ],
          ),
          isActive: currentStep >= 1,
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text(''),
          content: Column(
            children: [
              _controller.value.isInitialized
                  ? Container(
                      width: 0.9 * width,
                      height: ((0.9 * width) * (9 / 16)) + 10,
                      child: Column(
                        children: [
                          Container(
                            width: 0.9 * width,
                            height: (0.9 * width) * (9 / 16),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        _controller.play();
                                      }
                                    });
                                  },
                                ),
                                Icon(
                                  ((!_controller.value.isPlaying) ||
                                          (_controller.value.position ==
                                              _controller.value.duration))
                                      ? Icons.play_arrow
                                      : null,
                                  color: Colors.white,
                                  size: 60,
                                ),
                              ],
                            ),
                          ),
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            padding: EdgeInsets.only(
                              top: 0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
              SizedBox(
                height: height * 0.05,
              ),
              Image.asset('assets/protocol.png'),
            ],
          ),
          isActive: currentStep >= 2,
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: Text('Third'),
          content: Column(children: [
            SizedBox(height: height * 0.02),
            Text(
              "-Press the start button once you are ready to do the protocol.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: height * 0.02),
            Text(
              "-Once you finish press the end button.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
              ),
            ),
            SizedBox(height: height * 0.02),
            Container(
              width: width*0.6,
              height: 100,
              child: _isDone_2
                  ? Image.asset(
                      'assets/Done.png',
                    )
                  : _isLoading_2
                      ? CircularProgressIndicator()
                      : IconButton(
                        onPressed: () {
                          _startProcess(2);
                        },
                        icon: Icon(Icons.play_arrow,size: 50,),
                        color: Colors.blue[900],
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[50])),
                      ),
            ),
          ]),
          isActive: currentStep >= 3,
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
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
            fontSize: 25,
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
