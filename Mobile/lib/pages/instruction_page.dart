import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:modern_login/pages/instructions_screen/instruction_page1.dart';
import 'package:modern_login/pages/instructions_screen/instruction_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'instructions_screen/instruction_page2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Introduction Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnBoardingPage(),
    );
  }
}

// class OnBoardingPage extends StatelessWidget {
//   PageController _controller = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//           title: "Welcome",
//           body: "follow our instructions to get best results",
//           image: Center(child: Icon(Icons.integration_instructions_outlined, size: 100.0)),
//         ),
//         PageViewModel(
//           title: "Discover",
//           body: "This is the second page of the introduction.",
//           image: Center(child: Icon(Icons.cake, size: 100.0)),
//         ),
//         PageViewModel(
//           title: "Enjoy",
//           body: "This is the third page of the introduction.",
//           image: Center(child: Icon(Icons.mood, size: 100.0)),
//         ),
//       ],
//       onDone: () {
//         // When done button is press
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => instruction()),
//         );
//       },
//       onSkip: () {
//         // You can also override onSkip callback
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (_) => instruction()),
//         );
//       },
//       showSkipButton: true,
//       skip: const Icon(Icons.skip_next),
//       next: const Icon(Icons.arrow_forward),
//       done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
//       dotsDecorator: DotsDecorator(
//         size: const Size.square(10.0),
//         activeSize: const Size(22.0, 10.0),
//         activeShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25.0),
//         ),
//       ),
//     );
//   }
// }
//
// class instruction extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Page"),
//       ),
//       body: Center(
//         child: Text("This is the home page"),
//       ),
//     );
//   }
// }
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  var number_of_pages = 3;

  PageController _controller = PageController();

  bool onLastPage= false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage =(index == 2);
            });
          },
          children: [
            instructionPage1(),
            instructionPage2(),
            instructionPage3(),
          ],
        ),
        Container(
            alignment: Alignment(0, 0.8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context){
                    return instruction();
                  }));}, child: Text("Skip")),
                  SmoothPageIndicator(controller: _controller, count: number_of_pages),
                  onLastPage ?
                  GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){
                    return instruction();
                  }));},child: Text("Done")) :
                  GestureDetector(onTap: (){_controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn,);},child: Text("Next")),
                ]))
      ]),
    );
  }
}
class instruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Text("This is the home page"),
      ),
    );
  }
}