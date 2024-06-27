import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:modern_login/pages/Exersice_page.dart';
import 'package:modern_login/pages/Edit_profile.dart';
import 'package:modern_login/pages/Splash.dart';
import 'package:modern_login/pages/home_page.dart';
import 'package:modern_login/pages/severity_page.dart';
import 'package:modern_login/pages/instruction_page.dart';

import 'instruction_page.dart';
import 'login_page.dart';

class MainPage extends StatelessWidget {
  //const MainPage({super.key});

  var width, height;

  List home_imgs = [
    "assets/profile.jpg",
    "assets/instructions.jpg",
    "assets/exercises.png",
    "assets/data.png",
    "assets/Analysis.png",
  ];

  List imgs_label = [
    "Profile",
    "Instructions",
    "Exercise",
    "Severity",
    "Statistics",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()),
                  );
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
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            height: height * 0.2,
            width: width,
            child:
                //Column(children: [
                // Padding(
                //   padding: EdgeInsets.only(
                //     //top: 10,
                //     //right: 10,
                //     //left: 10,
                //   ),
                //   child:
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // InkWell(
                //   onTap: () {},
                //   child: Icon(
                //     Icons.sort,
                //     color: Colors.white,
                //     size: 40,
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(
                    left: 0.4 * width,
                    //bottom: 0.11 * height,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      //SizedBox(height: 5,),
                      Text(
                        "Page",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: 0.03 * width,
                    bottom: 0.1 * height,
                  ),
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
                        //color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/exit.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            height: height * 0.8,
            width: width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 0.05 * height,
                        //left:  0.1 * width,
                        //vertical: 0.05 * height,
                        //horizontal: 0.10 * width,
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
                            // boxShadow: [
                            //     BoxShadow(
                            //       color: Colors.black26,
                            //       spreadRadius: 2,
                            //       blurRadius: 8,
                            //     ),
                            //   ]
                          ),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Splash()),
                                );
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
                                      builder: (context) => instruction()),
                                );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                                      builder: (context) => ExercisePage()),
                                );
                                //print("Hi");
                              },
                              splashColor: Colors.black12,
                              child: Column(
                                children: [
                                  Ink.image(
                                    image: AssetImage(home_imgs[2]),
                                    fit: BoxFit.cover,
                                    width: 0.3 * width,
                                    height: 0.15 * height,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    imgs_label[2],
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
                                      builder: (context) => SeverityPage()),
                                );
                              },
                              splashColor: Colors.black12,
                              child: Column(
                                children: [
                                  Ink.image(
                                    image: AssetImage(home_imgs[3]),
                                    fit: BoxFit.cover,
                                    width: 0.3 * width,
                                    height: 0.15 * height,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    imgs_label[3],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                                print("Hi");
                              },
                              splashColor: Colors.black12,
                              child: Column(
                                children: [
                                  Ink.image(
                                    image: AssetImage(home_imgs[4]),
                                    fit: BoxFit.cover,
                                    width: 0.3 * width,
                                    height: 0.15 * height,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    imgs_label[4],
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
          ),
        ],
      ),
    ));
  }
}