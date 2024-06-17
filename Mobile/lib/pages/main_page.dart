import 'package:flutter/material.dart';

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

    return Scaffold(
        body: Container(
      //color: Colors.white,
      height: height,
      width: width,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
            ),
            height: height * 0.2,
            width: width,
            child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      right: 10,
                      left: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage('assets/instructions.jpg'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      left: 70,
                      right: 70,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi,",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        //SizedBox(height: 5,),
                        Text(
                          "Misara",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  )
                ]),
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
                                print("Hi");
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
                                print("Hi");
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
                                print("Hi");
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
                                print("Hi");
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
