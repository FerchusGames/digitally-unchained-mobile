import 'package:flutter/material.dart';
import 'package:digitally_unchained/collections/screens.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  int selectedPage = 0;
  TabController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        TabController(length: 2, initialIndex: selectedPage, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabs'),
      ),
      body: Column(
        children: [
          Expanded(
              child: TabBarView(
                controller: controller,
                children: [
                  Animals(),
                  Objects(),
                ],
              )),
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(width: 1, color: Colors.lightGreen),
            )),
            child: Material(
              child: TabBar(
                controller: controller,
                // indicator: BoxDecoration(
                //   color: Colors.lightGreen,
                // ),
                labelColor: Colors.lightGreen,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Container(
                      child: Text('Animals'),
                    ),
                  ),
                  Tab(
                    child: Container(
                      child: Text('Objects'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
