// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// DatabaseReference dbRef = FirebaseDatabase.instance.ref("data");
//
//
// class HomePage extends StatelessWidget {
//   HomePage({super.key});
//
//   final user = FirebaseAuth.instance.currentUser!;
//
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: signUserOut,
//             icon: Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text("Logged IN as :"+ user.email!),
//             ),
//           ),
//           // Other widgets for the rest of the page body
//         ],
//       ),
//       backgroundColor: Colors.blueAccent,
//
//     );
//   }
// }
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);
//
//   final user = FirebaseAuth.instance.currentUser!;
//   final DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("data");
//
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   void writeData() {
//     // Data you want to write
//     Map<String, dynamic> newData = {
//       'message': 'Hello, Firebase!',
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//     };
//
//     // Push the new data to the database
//     dbRef.push().set(newData)
//         .then((_) {
//       print("Data written successfully!");
//     })
//         .catchError((error) {
//       print("Error writing data: $error");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: signUserOut,
//             icon: Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text("Logged IN as: ${user.email}"),
//             ),
//           ),
//           // Add the button here
//           ElevatedButton(
//             onPressed: writeData,
//             child: Text('Write Data to Firebase'),
//           ),
//           // Other widgets for the rest of the page body
//         ],
//       ),
//       backgroundColor: Colors.blueAccent,
//     );
//   }
// }
/**************************************************************************************/
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import '../Models/user_info.dart';
//
// class HomePage extends StatefulWidget {
//   HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final user = FirebaseAuth.instance.currentUser!;
//   final DatabaseReference dbRef =
//   FirebaseDatabase.instance.reference().child("data");
//
//   TextEditingController _textFieldController1 = TextEditingController();
//   TextEditingController _textFieldController2 = TextEditingController();
//   TextEditingController _textFieldController3 = TextEditingController();
//   TextEditingController _textFieldController4 = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     dbRef.child(user.uid).get().then((DataSnapshot data) {
//       if (data.value != null) {
//         final dynamic dataMap = data.value;
//         print(dataMap);
//         if (dataMap is Map) {
//           final UserInfoooo info = UserInfoooo.fromJson(dataMap);
//           _textFieldController1.text = info.name;
//           _textFieldController2.text = info.age;
//           _textFieldController3.text = info.weight;
//           _textFieldController4.text = info.length;
//           setState(() {});
//         } else {
//           print("Error: Data is not in the expected format");
//         }
//       }
//     }).catchError((error) {
//       print("Error reading data: $error");
//     });
//   }
//
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }
//
//   void writeData() {
//     UserInfoooo userinfo = UserInfoooo(
//       name: _textFieldController1.text.trim(),
//       age: _textFieldController2.text.trim(),
//       weight: _textFieldController3.text.trim(),
//       length: _textFieldController4.text.trim(),
//     );
//
//     dbRef.child(user.uid).set(userinfo.toJson()).then((_) {
//       print("Data written successfully!");
//     }).catchError((error) {
//       print("Error writing data: $error");
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             onPressed: signUserOut,
//             icon: Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text("Logged IN as: ${user.email}"),
//               ),
//             ),
//             for (int i = 1; i <= 4; i++)
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   keyboardType: i != 1 ? TextInputType.number : TextInputType.name,
//                   controller: i == 1
//                       ? _textFieldController1
//                       : i == 2
//                       ? _textFieldController2
//                       : i == 3
//                       ? _textFieldController3
//                       : _textFieldController4,
//                   decoration: InputDecoration(
//                     hintText: 'Enter message $i',
//                   ),
//                 ),
//               ),
//             ElevatedButton(
//               onPressed: () {
//                 writeData();
//               },
//               child: Text('Write Data to Firebase'),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.blueAccent,
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/user_info.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child("data");

  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();

  List<String> fieldTitles = ['Name', 'Age', 'Weight', 'Length'];
  var flag=0;
  @override
  void initState() {
    super.initState();
    dbRef.child(user.uid).get().then((DataSnapshot data) {
      if (data.value != null) {
        final dynamic dataMap = data.value;
        print(dataMap);
        if (dataMap is Map) {
          final UserInfoooo info = UserInfoooo.fromJson(dataMap);
          _textFieldController1.text = info.name;
          _textFieldController2.text = info.age;
          _textFieldController3.text = info.weight;
          _textFieldController4.text = info.length;
          setState(() {});
        } else {
          print("Error: Data is not in the expected format");
        }
      }
    }).catchError((error) {
      print("Error reading data: $error");
    });
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void writeData() {
    UserInfoooo userinfo = UserInfoooo(
      name: _textFieldController1.text.trim(),
      age: _textFieldController2.text.trim(),
      weight: _textFieldController3.text.trim(),
      length: _textFieldController4.text.trim(),
    );

    dbRef.child(user.uid).set(userinfo.toJson()).then((_) {
      print("Data written successfully!");
    }).catchError((error) {
      print("Error writing data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Logged IN as: ${user.email}"),
              ),
            ),
            for (int i = 0; i < fieldTitles.length; i++)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(style: TextStyle(color: Colors.white),
                  keyboardType: i != 0 ? TextInputType.number : TextInputType.text,
                  controller: i == 0
                      ? _textFieldController1
                      : i == 1
                      ? _textFieldController2
                      : i == 2
                      ? _textFieldController3
                      : _textFieldController4,
                  maxLength: i ==0?21 : i==1?3 : i==2?3 : 3,
                  onChanged: i ==1?(value) {
                    flag=0;
                    if (int.tryParse(value) != null) {
                      int lengthValue = int.parse(value);
                      if (lengthValue > 130) {
                        flag =1;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maximum value allowed is 130'),
                          ),
                        ); // Set the value to 300 if it's greater
                      }
                    }
                  }
                  :i==2?(value) {
                    flag=0;
                    if (int.tryParse(value) != null) {
                      int lengthValue = int.parse(value);
                      if (lengthValue > 500) {
                        flag =1;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maximum value allowed is 500'),
                          ),
                        ); // Set the value to 300 if it's greater
                      }
                    }
                  }
                  :(value) {
                    flag=0;
                    if (int.tryParse(value) != null) {
                      int lengthValue = int.parse(value);
                      if (lengthValue > 300) {
                        flag =1;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maximum value allowed is 300'),
                          ),
                        ); // Set the value to 300 if it's greater
                      }
                    }
                  },



                  decoration: InputDecoration(
                    hintText: 'Enter ${fieldTitles[i]}',
                    labelText: fieldTitles[i],labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20)
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                flag ==0 ?writeData():1;

              },
              child: Text('Write Data to Firebase'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueAccent,
    );
  }
}

