import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';

import '../collections/global_data.dart';
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
                  shrinkWrap: true, // ensures that the ListView doesn't expand infinitely within the Column
                  physics: NeverScrollableScrollPhysics(), // ensures that the ListView doesn't interfere with the outer SingleChildScrollView
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ArticleContainer(
                          title: 'Blocking explicit websites with a DNS',
                          imagePath: 'images/dns_cloudflare.jpg',
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
