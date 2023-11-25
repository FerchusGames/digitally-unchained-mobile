import 'dart:io';

import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:flutter/material.dart';
import '../collections/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class Product_Edit extends StatefulWidget {
  String? id;
  String? name = '';
  String? price = '';
  String? description = '';
  String? image = '';

  Product_Edit(this.id, this.name, this.price, this.description, this.image)
      : super();

  @override
  State<Product_Edit> createState() => _Product_EditState();
}

class _Product_EditState extends State<Product_Edit> {
  String id = '';
  String name = '';
  String price = '';
  String description = '';
  String image = '';

  File? tmpImage = null;
  final picker = ImagePicker();

  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  Dio dio = new Dio();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id = widget.id!;
      nameTextController.text = widget.name!;
      priceTextController.text = widget.price!;
      descriptionTextController.text = widget.description!;
      image = widget.image!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: Color(MyColors.backgroundMain),
        appBar: AppBar(
          backgroundColor: Color(MyColors.backgroundMain),
          title: Text("Edit a Product"),
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
          child: Icon(Icons.edit),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: ListView(
          children: [
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: tmpImage == null
                      ? Image.network(image, fit: BoxFit.cover,)
                      : Image.file(tmpImage!, fit: BoxFit.cover,)),
            ),
            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () async {
                  showOptions();
                },
                child: Text(
                  'Change Image',
                  style: TextStyles.buttonText,
                ),
              ),
            ),
            SizedBox(height: 32,),
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
        'https://digitallyunchained.rociochavezml.com/php/edit_product.php');
    var response = await http.post(url, body: {
      'id': widget.id,
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

  Future<void> uploadImage() async {

    try {
      String filename = tmpImage!.path.split('/').last;
      FormData formData = new FormData.fromMap({
        'id': id,
        'file': await MultipartFile.fromFile(tmpImage!.path, filename: filename)
      });

      await dio
          .post(
          'https://digitallyunchained.rociochavezml.com/php/upload_product_image.php',
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
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
    );

    if (cropped != null) {
      setState(() {
        tmpImage = File(cropped.path);
      });
    }
  }
}
