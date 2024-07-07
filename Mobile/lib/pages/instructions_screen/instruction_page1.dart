import 'package:flutter/material.dart';

class instructionPage1 extends StatelessWidget {
  const instructionPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Linear gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.white54], // Replace with your desired colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Adjust the value as needed
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: Icon(
                Icons.battery_charging_full_outlined, // Use your desired icon
                size: 100, // Adjust the size as needed
                color: Colors.blue.shade900,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Battery working around 45 minute.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
