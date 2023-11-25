import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/my_widgets.dart';
import 'package:flutter/material.dart';
import '../collections/text_styles.dart';
import 'package:http/http.dart' as http;

class Product_Edit extends StatefulWidget {

  String? id;
  String? name = '';
  String? price = '';
  String? description = '';
  String? image = '';

  Product_Edit(this.id, this.name, this.price, this.description, this.image) : super();

  @override
  State<Product_Edit> createState() => _Product_EditState();
}

class _Product_EditState extends State<Product_Edit> {

  String id = '';
  String name = '';
  String price = '';
  String description = '';

  final nameTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final descriptionTextController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nameTextController.text = widget.name!;
      priceTextController.text = widget.price!;
      descriptionTextController.text = widget.description!;
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
    var url = Uri.parse('https://digitallyunchained.rociochavezml.com/php/edit_product.php');
    var response = await http.post(url, body: {
      'id' : widget.id,
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
