import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class SeverityPage extends StatefulWidget {
  const SeverityPage({super.key});

  @override
  State<SeverityPage> createState() => _SeverityPageState();
}

class _SeverityPageState extends State<SeverityPage> {
  var width, height;

  RawDatagramSocket? udpSocket;
  String? data;

  int currentStep = 0;
  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  @override
  void initState() {
    super.initState();
    setupUDP();
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
            children: [Text('Received data: $data')],
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
        child: Stepper(
          type: StepperType.horizontal,
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
    );
  }
}
