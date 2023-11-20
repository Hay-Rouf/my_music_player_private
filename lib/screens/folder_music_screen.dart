import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class FolderMusics extends GetView<MainController> {
  const FolderMusics({Key? key, required this.dir, required this.title})
      : super(key: key);
  final String dir;
  final String title;

  @override
  Widget build(BuildContext context) {
    List<String> musics = controller.getFolderMusics(dir);
    int adInd = musics.length <= 4 ? musics.length : 4;
    return Scaffold(
      floatingActionButton: Floater(),
      bottomNavigationBar: BannerWidget(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
            adManager.loadInterstitialAd();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 18),
        itemCount: musics.length + 1,
        itemBuilder: (_, index) {
          if (index == adInd) {
            return NativeAdsWidget(widget: SizedBox.shrink());
          }
          String data = musics[getDestinationItemIndex(index)];
          // String data = musics[index];
          String folderName = data.split('/').last;
          return ListTile(
            onTap: () {
              controller.setPlayer(
                  filesData: controller.testFunc(musics), initIndex: index);
            },
            title: Text(folderName.replaceAll('.mp3', '')),
            leading: Icon(
              Icons.music_note,
              size: 30,
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height*.08,
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.music_note,
            //         size: 30,
            //       ),
            //       SizedBox(
            //         width: 30,
            //       ),
            //       Expanded(child: Text(folderName.replaceAll('.mp3', ''))),
            //     ],
            //   ),
            // ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}
