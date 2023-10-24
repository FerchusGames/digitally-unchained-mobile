import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/text_styles.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(MyColors.backgroundMain),
        appBar: AppBar(
          title: Text('Products'),
          backgroundColor: Color(MyColors.backgroundMain),
          titleTextStyle: TextStyles.screenTitle,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/product_create");
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightGreen,
          elevation: 0,
        ),
        body: ListView(
          children: [],
        ));
  }
}
