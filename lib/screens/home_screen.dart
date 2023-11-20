import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class HomeScreen extends GetView<MainController> {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = '/home';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: Floater(),
        bottomNavigationBar: BannerWidget(),
        appBar: AppBar(
          title: Text('Music Player'),
          centerTitle: true,
          actions: [IconButton(onPressed: () async {
            await showSearch<String>(
            context: context,
            delegate: CustomDelegate(),
            );
          }, icon: Icon(Icons.search))],
          bottom: TabBar(tabs: const [
            Tab(
              text: 'Folders',
            ),
            Tab(
              text: 'Songs',
            )
          ]),
        ),
        body: TabBarView(
          children: const [
            Folders(),
            AllSongs(),
          ],
        ),
      ),
    );
  }
}
