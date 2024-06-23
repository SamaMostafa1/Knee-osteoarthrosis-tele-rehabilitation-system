// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:modern_login/pages/instructions_screen/instruction_page1.dart';
// import 'package:modern_login/pages/instructions_screen/instruction_page3.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//
// import 'Exersice_page.dart';
// import 'home_page.dart';
// import 'instructions_screen/instruction_page2.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//
//       home: OnBoardingPage(),
//     );
//   }
// }
//
// class OnBoardingPage extends StatefulWidget {
//   const OnBoardingPage({super.key});
//
//   @override
//   State<OnBoardingPage> createState() => _OnBoardingPageState();
// }
//
// class _OnBoardingPageState extends State<OnBoardingPage> {
//   var number_of_pages = 3;
//
//   PageController _controller = PageController();
//
//   bool onLastPage= false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(children: [
//         PageView(
//           controller: _controller,
//           onPageChanged: (index) {
//             setState(() {
//               onLastPage =(index == 2);
//             });
//           },
//           children: [
//             instructionPage1(),
//             instructionPage2(),
//             instructionPage3(),
//           ],
//         ),
//         Container(
//             alignment: Alignment(0, 0.8),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   GestureDetector(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context){
//                     return instruction();
//                   }));}, child: Text("Skip")),
//                   SmoothPageIndicator(controller: _controller, count: number_of_pages),
//                   onLastPage ?
//                   GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){
//                     return instruction();
//                   }));},child: Text("Done")) :
//                   GestureDetector(onTap: (){_controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn,);},child: Text("Next")),
//                 ]))
//       ]),
//     );
//   }
// }
// class instruction extends StatelessWidget {
//   //const MainPage({super.key});
//
//   var width, height;
//
//   List home_imgs = [
//     "assets/profile.jpg",
//     "assets/instructions.jpg",
//   ];
//
//   List imgs_label = [
//     "Profile",
//     "Instructions",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//
//     void _showDialog(BuildContext context) {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Confirm Action'),
//             content: Text('Are you sure you want to exit the application?'),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text('Yes'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   SystemNavigator.pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//
//     return Scaffold(
//         body: Container(
//           // container have buttons
//           color: Colors.yellow,
//           height: height,
//           width: width,
//           child: Column(
//             children: [
//               Container(
//                 // container above in title
//                 decoration: BoxDecoration(
//                   color: Colors.green[900],
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(50),
//                     bottomRight: Radius.circular(50),
//                   ),
//                 ),
//                 height: height * 0.2,
//                 width: width,
//                 child:
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Instruction page",
//                       style: TextStyle(
//                         fontSize: 30,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                     Container(
//                       // margin: EdgeInsets.only(
//                       //   left: 30,
//                       //   bottom: 90
//                       //   ,
//                       // ),
//                       height: 50,
//                       width: 50,
//                       color: Colors.yellow,
//
//                       child: InkWell(
//                         onTap: () {
//                           _showDialog(context);
//                         },
//                         // splashColor: Colors.black12,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               width: 2,
//                               color: Colors.red,
//                             ),
//                             image: DecorationImage(
//                               image: AssetImage('assets/exit.png'),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Column(
//                 children: [
//                   Container(color: Colors.red,
//                     margin: EdgeInsets.only(
//                       top: 0.05 * height,
//                       //left:  0.1 * width,
//                       //vertical: 0.05 * height,
//                       //horizontal: 0.10 * width,
//                     ),
//                     child: Material(
//                       color: Colors.blue[900],
//                       elevation: 8,
//                       borderRadius: BorderRadius.circular(20),
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           border: Border.all(
//                             width: 5,
//                             color: Colors.blue.shade900,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: InkWell(
//                             onTap: () {
//                               // Navigator.push(
//                               //   context,
//                               //   MaterialPageRoute(
//                               //       builder: (context) => HomePage()),
//                               // );
//                               print("fdfgdg");
//                             },
//                             splashColor: Colors.black12,
//                             child: Column(
//                               children: [
//                                 Ink.image(
//                                   image: AssetImage(home_imgs[0]),
//                                   fit: BoxFit.cover,
//                                   width: 0.3 * width,
//                                   height: 0.15 * height,
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   imgs_label[0],
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     letterSpacing: 1,
//                                   ),
//                                 )
//                               ],
//                             )),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(
//                       top: 0.05 * height,
//                     ),
//                     child: Material(
//                       color: Colors.blue[900],
//                       elevation: 8,
//                       borderRadius: BorderRadius.circular(20),
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           border: Border.all(
//                             width: 5,
//                             color: Colors.blue.shade900,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: InkWell(
//                             onTap: () {
//                               print("Hiiiiiiiiiiiiiiiiiiiiiii");
//                             },
//                             splashColor: Colors.black12,
//                             child: Column(
//                               children: [
//                                 Ink.image(
//                                   image: AssetImage(home_imgs[1]),
//                                   fit: BoxFit.cover,
//                                   width: 0.3 * width,
//                                   height: 0.15 * height,
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   imgs_label[1],
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     letterSpacing: 1,
//                                   ),
//                                 )
//                               ],
//                             )),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:modern_login/pages/instructions_screen/instruction_page1.dart';
import 'package:modern_login/pages/instructions_screen/instruction_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import 'Exersice_page.dart';
import 'home_page.dart';
import 'instructions_screen/instruction_page2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: instruction(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  var number_of_pages = 3;

  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
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
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return instruction();
                            }));
                      },
                      child: Text("Skip")),
                  SmoothPageIndicator(
                      controller: _controller, count: number_of_pages),
                  onLastPage
                      ? GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return instruction();
                            }));
                      },
                      child: Text("Done"))
                      : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Text("Next")),
                ]))
      ]),
    );
  }
}

class instruction extends StatelessWidget {
  var width, height;

  List home_imgs = [
    "assets/troos.png",
    "assets/video.jpg",
  ];

  List imgs_label = [
    "Hardware",
    "video",
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    void _showDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Action'),
            content: Text('Are you sure you want to exit the application?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        body: Container(
          color: Colors.white,
          height: height,
          width: width,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    // container above in title
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    height: height * 0.2,
                    width: width,
                  ),
                  Positioned(
                    top: 16, // Adjust as needed
                    right: 16, // Adjust as needed
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _showDialog(context);
                        },
                        splashColor: Colors.black12,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 2,
                              color: Colors.white,
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/exit.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.1, // Adjust this value to move the text down
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Instruction page",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(
                      top: 0.05 * height,
                    ),
                    child: Material(
                      color: Colors.blue[900],
                      elevation: 8,
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 5,
                            color: Colors.blue.shade900,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnBoardingPage()),
                              );
                              print("fdfgdg");
                            },
                            splashColor: Colors.black12,
                            child: Column(
                              children: [
                                Ink.image(
                                  image: AssetImage(home_imgs[0]),
                                  fit: BoxFit.cover,
                                  width: 0.3 * width,
                                  height: 0.15 * height,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  imgs_label[0],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 0.05 * height,
                    ),
                    child: Material(
                      color: Colors.blue[900],
                      elevation: 8,
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            width: 5,
                            color: Colors.blue.shade900,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoPage()),
                              );
                              print("fdfgdg");
                            },
                            splashColor: Colors.black12,
                            child: Column(
                              children: [
                                Ink.image(
                                  image: AssetImage(home_imgs[1]),
                                  fit: BoxFit.cover,
                                  width: 0.3 * width,
                                  height: 0.15 * height,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  imgs_label[1],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  late bool _isVideoEnded;

  @override
  void initState() {
    super.initState();
    _isVideoEnded = false;
    _controller = VideoPlayerController.asset('assets/Protocol.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_videoListener);
      });
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      setState(() {
        _isVideoEnded = true;
      });
    } else {
      setState(() {
        _isVideoEnded = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Instructions'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              if (_isVideoEnded) {
                _controller.seekTo(Duration.zero); // Rewind video to the beginning
              }
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying && !_isVideoEnded
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}