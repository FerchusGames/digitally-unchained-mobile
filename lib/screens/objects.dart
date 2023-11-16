import 'package:flutter/material.dart';

class Objects extends StatefulWidget {
  const Objects({super.key});

  @override
  State<Objects> createState() => _ObjectsState();
}

class _ObjectsState extends State<Objects> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Objects',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
