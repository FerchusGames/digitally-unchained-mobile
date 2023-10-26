import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:flutter/material.dart';
import '../collections/text_styles.dart';
import 'package:http/http.dart' as http;

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
          backgroundColor: Colors.lightGreen,
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
    var url = Uri.parse('https://digitallyunchained.rociochavezml.com/php/add_product.php');
    var response = await http.post(url, body: {
      'name' : name,
      'price' : price,
      'description' : description,
    }).timeout(Duration(seconds: 90));

    if(response.body != '0')
    {
      resetTextControllers();
      Navigator.pop(context);
    }

    else
    {
      MyFunctions.showAlert("There was an error, please report to the administrator", context);
    }
  }

  void resetTextControllers() {
    setState(() {
      nameTextController.text = '';
      priceTextController.text = '';
      descriptionTextController.text = '';
    });
  }
}
