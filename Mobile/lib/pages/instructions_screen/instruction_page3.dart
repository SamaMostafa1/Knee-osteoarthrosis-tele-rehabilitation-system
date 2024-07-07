import 'package:flutter/material.dart';

class instructionPage3 extends StatelessWidget {
  const instructionPage3({super.key});

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
                Icons.chair_alt, // Use your desired icon
                size: 100, // Adjust the size as needed
                color: Colors.black,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.0), // Add padding to control line breaks
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                children: [
                  TextSpan(text: 'its prefer to use chair without any arms. '),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
