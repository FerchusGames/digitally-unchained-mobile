import 'package:flutter/material.dart';

import '../collections/my_colors.dart';
import '../collections/text_styles.dart';

class ArticleContainer extends StatelessWidget {
  const ArticleContainer({
    super.key,
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Image.asset(
                imagePath,
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
            child: Text(
              title,
              style: TextStyles.articleTitle,
            ),
          )
        ],
      ),
    );
  }
}
