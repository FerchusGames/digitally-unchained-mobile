import 'package:flutter/material.dart';

class Animals extends StatefulWidget {
  const Animals({super.key});

  @override
  State<Animals> createState() => _AnimalsState();
}

class _AnimalsState extends State<Animals> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Animals',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
