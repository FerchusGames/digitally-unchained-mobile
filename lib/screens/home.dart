import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/my_colors.dart';

import '../collections/global_data.dart';
import '../widgets/article_container.dart';

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
  double itemVerticalSpace = 32;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.backgroundMain),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(MyColors.backgroundMain),
                  border: Border(
                      bottom: BorderSide(
                          color: Color(MyColors.darkIconBackground)))),
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
                    onTap: () async {
                      await Navigator.of(context).pushNamed('/profile');
                      refresh();
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
                  SizedBox(width: 20,)
                ],
              ),
            ),
            SizedBox(
              height: itemVerticalSpace,
              width: double.infinity,
            ),
            ArticleContainer(
              title: 'Blocking explicit websites with a DNS',
              imagePath: 'images/dns_cloudflare.jpg',
            ),
            SizedBox(
              height: itemVerticalSpace,
              width: double.infinity,
            ),
            ArticleContainer(
              title: 'How to leave social media and not die trying.',
              imagePath: 'images/social_media_trash_can.jpg',
            ),
            SizedBox(
              height: itemVerticalSpace,
              width: double.infinity,
            ),
            ArticleContainer(
              title: 'Why social media affects your freedom.',
              imagePath: 'images/people_looking_at_phone.jpg',
            ),
            SizedBox(
              height: itemVerticalSpace,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
