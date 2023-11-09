import 'dart:io';

import 'package:digitally_unchained/collections/errors.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitally_unchained/collections/pref_keys.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:digitally_unchained/collections/global_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String firstName = '';
  String lastName = '';
  String email = '';

  File? image = null;
  final picker = ImagePicker();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  double textFieldVerticalSpace = 40;
  double labelVerticalSpace = 8;

  Dio dio = new Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.backgroundMain),
      body: GestureDetector(
        onTap: () {
          MyFunctions.unfocusWidgets(context);
        },
        child: ListView(
          children: [
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color(MyColors.darkIconBackground),
                ),
              ),
            ),
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            GestureDetector(
              onTap: () {
                showOptions();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Icon(
                        Icons.edit,
                        color: Color(MyColors.darkIconBackground),
                      ),
                      ClipOval(
                        child: Container(
                          height: 160,
                          width: 160,
                          child: GlobalData.profilePicture != null
                              ? Image.file(
                                  GlobalData.profilePicture!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'images/default_avatar.jpg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'First Name',
                style: TextStyles.label,
              ),
            ),
            SizedBox(
              height: labelVerticalSpace,
              width: double.infinity,
            ),
            DarkTextField(
              textController: firstNameController,
            ),
            SizedBox(
              height: textFieldVerticalSpace,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Last Name',
                style: TextStyles.label,
              ),
            ),
            SizedBox(
              height: labelVerticalSpace,
              width: double.infinity,
            ),
            DarkTextField(
              textController: lastNameController,
            ),
            SizedBox(
              height: textFieldVerticalSpace,
              width: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Email Address',
                style: TextStyles.label,
              ),
            ),
            SizedBox(
              height: labelVerticalSpace,
              width: double.infinity,
            ),
            DarkTextField(
              textController: emailController,
            ),
            SizedBox(
              height: textFieldVerticalSpace,
              width: double.infinity,
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await sendData();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'SAVE CHANGES',
                  style: TextStyles.buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateProfileFromPrefs();
  }

  Future<void> updateProfileFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      firstNameController.text =
          prefs.getString(PrefKey.firstName) ?? Errors.noPrefKey;
      lastNameController.text =
          prefs.getString(PrefKey.lastName) ?? Errors.noPrefKey;
      emailController.text = prefs.getString(PrefKey.email) ?? Errors.noPrefKey;
    });
  }

  void showOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        selectImage(1);
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text('Take a picture')),
                            Icon(Icons.camera_alt, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      selectImage(2);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text('Choose from gallery')),
                          Icon(Icons.image, color: Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.red),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future selectImage(int option) async {
    var pickedFile;

    switch (option) {
      case 1:
        pickedFile = await picker.pickImage(source: ImageSource.camera);
        break;
      case 2:
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      if (pickedFile != null) {
        //image = File(pickedFile.path);
        crop(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }

  void crop(File file) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (cropped != null) {
      setState(() {
        image = File(cropped.path);
        GlobalData.profilePicture = File(cropped.path);
      });
    }
  }

  void setTextVariables() {
    firstName = firstNameController.text.trim();
    lastName = lastNameController.text.trim();
    email = emailController.text.trim();
  }

  Future<void> sendData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setTextVariables();

    var url = Uri.parse(
        'https://digitallyunchained.rociochavezml.com/php/edit_user.php');
    var response = await http.post(url, body: {
      'id': prefs.getString(PrefKey.id),
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    }).timeout(Duration(seconds: 90));

    if (response.body == '1') {
      await uploadImage();
      await updatePrefs();
      Navigator.pop(context);
    } else {
      MyFunctions.showAlert(
          "There was an error, please report to the administrator", context);
    }
  }

  Future<void> updatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(PrefKey.firstName, firstName);
    await prefs.setString(PrefKey.lastName, lastName);
    await prefs.setString(PrefKey.email, email);
  }

  Future<void> uploadImage() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      String filename = image!.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'id' : prefs.getString(PrefKey.id),
        'email' : prefs.getString(PrefKey.email),
        'file': await MultipartFile.fromFile(image!.path, filename: filename)
      });

      await dio.post('https://digitallyunchained.rociochavezml.com/php/upload_image.php',
      data: formData).then((value){
        if(value.toString() == '1')
          {
            print('Image uploaded successfully');
          }
        else
          {
            print(value.toString());
          }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
