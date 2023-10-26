import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';
import 'package:digitally_unchained/product_data.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<Product_Data> data = [];

  Future<List<Product_Data>> take_data() async {
    var url = Uri.parse(
        'https://digitallyunchained.rociochavezml.com/php/show_product.php');

    var response = await http.post(url).timeout(Duration(seconds: 90));

    print(response.body);

    var data = jsonDecode(response.body);

    List<Product_Data> registry = [];

    for (data in data) {
      registry.add(Product_Data.fromJson(data));
    }

    return registry;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshData();
  }

  void refreshData() {
    take_data().then((value)
    {
      setState(() {
        data.addAll(value);
        print(data);
      });
    });
  }

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
            Navigator.pushNamed(context, "/product_create").then((value){
              refreshData();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightGreen,
          elevation: 0,
        ),
        body: Column(
          children: [
            data.isEmpty ? Center(child: Text('No products'),) : Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(MyColors.backgroundAccent), width: 1)
                      )
                    ),
                      child: Text(data[index].name!,
                      style: TextStyles.textButton,),
                  );
                },
              ),
            )
          ],
        ));
  }
}
