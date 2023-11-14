import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';

import '../collections/global_data.dart';
import '../collections/my_functions.dart';
import '../collections/screens.dart';
import '../widgets/article_container.dart';
import 'package:digitally_unchained/collections/text_styles.dart';
import 'package:digitally_unchained/product_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  String firstName = '';
  String lastName = '';
  String email = '';

  Home({super.key});

  Home.withData(this.firstName, this.lastName, this.email);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product_Data> data = [];
  double itemVerticalSpace = 32;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.backgroundMain),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(MyColors.backgroundMain),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(MyColors.darkIconBackground),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.centerLeft,
                        height: 80,
                        child: Image.asset('images/du_logo_dark.png'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/profile')
                            .then((value) {
                          refreshData();
                        });
                      },
                      child: Center(
                        child: ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            child: FutureBuilder<String>(
                              future: MyFunctions.getProfilePicture(),
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  // Show a loading indicator while waiting for the future to complete
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  // Handle any errors that might have occurred
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  // Once the future completes, use the data to display the image
                                  return Image.network(snapshot.data!, fit: BoxFit.cover);
                                } else {
                                  // Handle the case where snapshot has no data
                                  return Center(child: Text('No image available'));
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: itemVerticalSpace,
                width: double.infinity,
              ),
              if (data.isEmpty)
                Center(
                  child: Text(
                    'No Products',
                    style: TextStyles.screenTitle,
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  // ensures that the ListView doesn't expand infinitely within the Column
                  physics: NeverScrollableScrollPhysics(),
                  // ensures that the ListView doesn't interfere with the outer SingleChildScrollView
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  child: Image.asset(
                                    "images/dns_cloudflare.jpg",
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: double.infinity,
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: Color(MyColors.backgroundAccent),
                                ),
                                height: 60,
                                width: double.infinity,
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data[index].name!,
                                        style: TextStyles.articleTitle,
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
                                                      data[index].description);
                                                })).then((value) {
                                          refreshData();
                                        });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Color(MyColors.greenMain),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showAlert(
                                            data[index].id, data[index].name);
                                      },
                                      child:
                                          Icon(Icons.delete, color: Colors.red),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: itemVerticalSpace,
                          width: double.infinity,
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteProduct(id) async {
    var url = Uri.parse(
        'https://digitallyunchained.rociochavezml.com/php/delete_product.php');
    var response = await http.post(url, body: {
      'id': id,
    }).timeout(Duration(seconds: 90));

    if (response.body != '0') {
      MyFunctions.showAlert("Product deleted successfully", context);
    } else {
      MyFunctions.showAlert(
          "There was an error, please report to the administrator", context);
    }
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
}
