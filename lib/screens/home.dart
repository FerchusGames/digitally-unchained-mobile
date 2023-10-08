import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/colors.dart';
import 'package:digitally_unchained/collections/text_styles.dart';

import '../widgets/article_container.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double itemVerticalSpace = 32;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(BACKGROUND_MAIN_COLOR),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(BACKGROUND_MAIN_COLOR),
                  border: Border(
                      bottom: BorderSide(color: DARK_ICON_BACKGROUND_COLOR))),
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
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 80,
                    child: Icon(
                      Icons.person,
                      color: DARK_ICON_BACKGROUND_COLOR,
                    ),
                  ),
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
}
