import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../collections/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';

class Product_Create extends StatefulWidget {
  const Product_Create({super.key});

  @override
  State<Product_Create> createState() => _Product_CreateState();
}

class _Product_CreateState extends State<Product_Create> {
  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  String name = '';
  String price = '';
  String description = '';

  File? image = null;
  final picker = ImagePicker();

  Dio dio = new Dio();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: Color(MyColors.backgroundMain),
        appBar: AppBar(
          backgroundColor: Color(MyColors.backgroundMain),
          title: Text("Create a Product"),
          titleTextStyle: TextStyles.screenTitle,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            setTextVariables();
            sendData();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: ListView(
          children: [
            DarkTextField(
              textController: nameTextController,
              label: "Name",
            ),
            DarkTextField(
              textController: priceTextController,
              label: "Price",
              inputType: TextInputType.number,
            ),
            DarkTextField(
                textController: descriptionTextController,
                label: "Description"),
            Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    showOptions();
                  },
                  child: Text('UPLOAD IMAGE')),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: image == null
                  ? Center(
                      child: Text(
                      'No Image Uploaded',
                      style: TextStyle(color: Colors.white),
                    ))
                  : Image.file(image!),
            ),
          ],
        ),
      ),
    );
  }

  void setTextVariables() {
    name = nameTextController.text.trim();
    price = priceTextController.text.trim();
    description = descriptionTextController.text.trim();
  }

  Future<void> sendData() async {
    var url = Uri.parse(
        'https://digitallyunchained.rociochavezml.com/php/add_product.php');
    var response = await http.post(url, body: {
      'name': name,
      'price': price,
      'description': description,
    }).timeout(Duration(seconds: 90));

    if (response.body != '0') {
      await uploadImage();
      resetTextControllers();
      Navigator.pop(context);
    } else {
      MyFunctions.showAlert(
          "There was an error, please report to the administrator", context);
    }
  }

  void resetTextControllers() {
    setState(() {
      nameTextController.text = '';
      priceTextController.text = '';
      descriptionTextController.text = '';
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
      });
    }
  }

  Future<void> uploadImage() async {
    try {
      String filename = image!.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'file': await MultipartFile.fromFile(image!.path, filename: filename)
      });

      await dio
          .post(
              'https://digitallyunchained.rociochavezml.com/php/upload_profile_picture.php',
              data: formData)
          .then((value) {
        if (value.toString() == '1') {
          print('Image uploaded successfully');
        } else {
          print(value.toString());
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
