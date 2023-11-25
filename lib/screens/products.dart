import 'package:digitally_unchained/collections/my_functions.dart';
import 'package:digitally_unchained/collections/screens.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshData();
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
            Navigator.pushNamed(context, "/product_create").then((value) {
              refreshData();
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: Column(
          children: [
            data.isEmpty
                ? Center(
              child: Text('No products'),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(MyColors.backgroundAccent),
                                  width: 1))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              data[index].name!,
                              style: TextStyles.textButton,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return Product_Edit(
                                              data[index].id,
                                              data[index].name,
                                              data[index].price,
                                              data[index].description,
                                              data[index].image);
                                        })).then((value) {
                                  refreshData();
                                });
                              },
                              child:
                              Icon(Icons.edit, color: Colors.green)),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () {
                                showAlert(
                                    data[index].id, data[index].name);
                              },
                              child:
                              Icon(Icons.delete, color: Colors.red)),
                        ],
                      ));
                },
              ),
            )
          ],
        ));
  }

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

  showAlert(id, name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('WARNING'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Do you really want to delete this product: '),
                  Text(name),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteProduct(id).then((value) {
                    refreshData();
                  });
                },
                child: Text('Accept'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  void refreshData() {
    data = [];
    take_data().then((value) {
      setState(() {
        data.addAll(value);
        print(data);
      });
    });
  }

  Future<void> deleteProduct(id) async {
    var url = Uri.parse('https://digitallyunchained.rociochavezml.com/php/delete_product.php');
    var response = await http.post(url, body: {
      'id' : id,
    }).timeout(Duration(seconds: 90));

    if(response.body != '0')
    {
      MyFunctions.showAlert("Product deleted successfully", context);
    }

    else
    {
      MyFunctions.showAlert("There was an error, please report to the administrator", context);
    }
  }
}
