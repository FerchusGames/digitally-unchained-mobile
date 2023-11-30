import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/widgets/dark_text_field.dart';

class ProductInfo extends StatefulWidget {
  ProductInfo(this.productImage, this.name, this.price, this.description) : super();

  String? productImage = '';
  String? name = '';
  String? price = '';
  String? description = '';

  @override
  State<ProductInfo> createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {

  double textFieldVerticalSpace = 40;
  double labelVerticalSpace = 8;

  String productImage = '';
  String name = '';
  String price = '';
  String description = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productImage = widget.productImage!;
    name = widget.name!;
    price = widget.price!;
    description = widget.description!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Info", style: TextStyle(color: Colors.white),), backgroundColor: Color(MyColors.backgroundMain)),
      backgroundColor: Color(MyColors.backgroundMain),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Name',
              style: TextStyles.label,
            ),
          ),
          SizedBox(
            height: labelVerticalSpace,
            width: double.infinity,
          ),
          DarkTextField(
            label: name,
            textController: TextEditingController(),
            isEnabled: false,
          ),
          SizedBox(
            height: textFieldVerticalSpace,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Price',
              style: TextStyles.label,
            ),
          ),
          SizedBox(
            height: labelVerticalSpace,
            width: double.infinity,
          ),
          DarkTextField(
            label: price,
            textController: TextEditingController(),
            isEnabled: false,
          ),
          SizedBox(
            height: textFieldVerticalSpace,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Description',
              style: TextStyles.label,
            ),
          ),
          SizedBox(
            height: labelVerticalSpace,
            width: double.infinity,
          ),
          DarkTextField(
            label: description,
            textController: TextEditingController(),
            isEnabled: false,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
              Radius.circular(20)),
              child: Image.network(
                productImage,
                fit: BoxFit.cover,
                //height: 200,
                width: double.infinity,
              ),
            ),
          )
        ],
      ),
    );
  }
}
