import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class HomeScreen extends GetView<MainController> {
  const HomeScreen({super.key});

  static const String id = '/home';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: Floater(),
        bottomNavigationBar: BannerWidget(),
        appBar: AppBar(
          title: Text('Music Player'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await showSearch<String>(
                    context: context,
                    delegate: CustomDelegate(),
                  );
                },
                icon: Icon(Icons.search))
          ],
          // bottom:
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * .2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Icon(Icons.favorite),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Icon(Icons.playlist_add),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Icon(Icons.recent_actors),
                    ),
                  ],
                ),
              ),
              TabBar(
                tabs: const [
                  Tab(text: 'Songs'),
                  Tab(text: 'Albums'),
                  Tab(text: 'Artists'),
                  Tab(text: 'Folders'),
                ],
              ),
              SizedBox(
                height: Get.height,
                // width: Get.width,
                child: TabBarView(
                  children: const [
                    AllSongs(),
                    Albums(),
                    Artists(),
                    Folders(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
