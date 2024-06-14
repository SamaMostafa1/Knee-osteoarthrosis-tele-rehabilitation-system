import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modern_login/pages/login_page.dart';
import 'package:modern_login/utils.dart';
import '../Models/user_info.dart';
import 'Splash.dart';
import '../utils.dart';
import '../resources/add_data.dart';

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
  var flag = 0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _imageUrl;
  bool showFields = false;
  bool showSave = false;
  void toggleFieldsVisibility() {
    setState(() {
      showFields = !showFields;
    });
  }

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

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Splash(),
        ));
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
  Uint8List ? _image;
  void selectImage() async{
    Uint8List img = await  pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    if(img!=null){
      saveProfile();
    }
  }

  void saveProfile() async{
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
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
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
                    child: IconButton(
                  onPressed: selectImage,
                  icon: (const Icon(Icons.add_a_photo)),
                ),
                  bottom: -10,
                  left: 80,
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Logged IN as: ${user.email}"),
              ),
            ),
            if (showFields)
              for (int i = 0; i < fieldTitles.length; i++)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
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
                            flag = 0;
                            if (int.tryParse(value) != null) {
                              int lengthValue = int.parse(value);
                              if (lengthValue > 130) {
                                flag = 1;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Maximum value allowed is 130'),
                                  ),
                                ); // Set the value to 300 if it's greater
                              }
                            }
                          }
                        : i == 2
                            ? (value) {
                                flag = 0;
                                if (int.tryParse(value) != null) {
                                  int lengthValue = int.parse(value);
                                  if (lengthValue > 500) {
                                    flag = 1;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Maximum value allowed is 500'),
                                      ),
                                    ); // Set the value to 300 if it's greater
                                  }
                                }
                              }
                            : (value) {
                                flag = 0;
                                if (int.tryParse(value) != null) {
                                  int lengthValue = int.parse(value);
                                  if (lengthValue > 300) {
                                    flag = 1;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Maximum value allowed is 300'),
                                      ),
                                    ); // Set the value to 300 if it's greater
                                  }
                                }
                              },
                    decoration: InputDecoration(
                        hintText: 'Enter ${fieldTitles[i]}',
                        labelText: fieldTitles[i],
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
            Row(
              children: [
                if (showFields) // Only show the "Save" button if showFields is true
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {

                        flag == 0 ? writeData() : 1;
                      },
                      child: Text('Save'),
                    ),
                  ),
                SizedBox(width: 5), // Adding spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: toggleFieldsVisibility,
                    child: Text(showFields ? 'Done' : 'Personal Information'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blueAccent,
    );
  }
}
