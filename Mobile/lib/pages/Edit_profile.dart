import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_login/pages/home_page.dart';
import 'package:modern_login/pages/login_page.dart';
import 'package:modern_login/utils.dart';
import '../Models/user_info.dart';
import 'Splash.dart';
import '../utils.dart';
import '../resources/add_data.dart';

class EditHomePage extends StatefulWidget {
  EditHomePage({Key? key}) : super(key: key);

  @override
  _EditHomePageState createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final DatabaseReference dbRef =
  FirebaseDatabase.instance.reference().child("data");

  TextEditingController _textFieldController1 = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  TextEditingController _textFieldController3 = TextEditingController();
  TextEditingController _textFieldController4 = TextEditingController();

  List<String> fieldTitles = ['Name', 'Age', 'Weight', 'Length'];
  var flag = 0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _imageUrl;

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
    fetchUserImage();
  }

  void writeData() {
    UserInfoooo userinfo = UserInfoooo(
      name: _textFieldController1.text.trim(),
      age: _textFieldController2.text.trim(),
      weight: _textFieldController3.text.trim(),
      length: _textFieldController4.text.trim(),
    );

    dbRef.child(user.uid).set(userinfo.toJson()).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data written successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      print("Data written successfully!");
    }).catchError((error) {
      print("Error writing data: $error");
    });
  }

  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    if (img != null) {
      saveProfile();
    }
  }

  void saveProfile() async {
    // String name =dbRef.child(user.uid).get().then((DataSnapshot data);
    String resp = await StoreData().saveData(name: user.uid, file: _image!);
  }

  Future<void> fetchUserImage() async {
    try {
      String downloadURL = await _storage.ref(user.uid).getDownloadURL();
      setState(() {
        _imageUrl = downloadURL;
      });
    } catch (error) {
      print("Error fetching image: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    height: 160,
                    color: Colors.blue[900],
                  ),
                ),
                _image != null
                    ? CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(_image!),
                )
                    : _imageUrl != null
                    ? CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(_imageUrl!),
                )
                    : const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                    "https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=",
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 90,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            for (int i = 0; i < fieldTitles.length; i++)
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  keyboardType:
                  i != 0 ? TextInputType.number : TextInputType.text,
                  controller: i == 0
                      ? _textFieldController1
                      : i == 1
                      ? _textFieldController2
                      : i == 2
                      ? _textFieldController3
                      : _textFieldController4,
                  maxLength: i == 0
                      ? 21
                      : i == 1
                      ? 3
                      : i == 2
                      ? 3
                      : 3,
                  onChanged: i == 1
                      ? (value) {
                    if (int.tryParse(value) != null) {
                      int lengthValue = int.parse(value);
                      if (lengthValue > 130) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Maximum value allowed is 130'),
                          ),
                        );
                      }
                    }
                  }
                      : i == 2
                      ? (value) {
                    if (int.tryParse(value) != null) {
                      int lengthValue = int.parse(value);
                      if (lengthValue > 500) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('Maximum value allowed is 500'),
                          ),
                        );
                      }
                    }
                  }
                      : (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter ${fieldTitles[i]}',
                    labelText: fieldTitles[i],
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    icon: i == 0
                        ? const Icon(Icons.account_box)
                        : i == 1
                        ? const Icon(Icons.calendar_month_outlined)
                        : i == 2
                        ? const Icon(Icons.accessibility)
                        : i == 3
                        ? const Icon(Icons.baby_changing_station)
                        : null,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: writeData,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Ensure background color is set correctly
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
