import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../constants.dart';

class GetMusics extends GetView<MainController> {
  const GetMusics({super.key, required this.musics, required this.title});

  final List<MusicModel> musics;
  final String title;

  @override
  Widget build(BuildContext context) {
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
          int realIndex = getDestinationItemIndex(index);
          MusicModel music = musics[realIndex];
          String musicName = music.displayNameWOExt;
          return ListTile(
            onTap: () {
              controller.setPlayer(filesData: musics, initIndex: realIndex);
            },
            title: Text(musicName),
            subtitle: Text(
              '${music.artist} | ${music.album}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  music.imageList,
                  height: 200,
                  width: 50,
                  fit: BoxFit.cover,
                )),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }
}

// class AlbumMusics extends GetView<MainController> {
//   const AlbumMusics({super.key, required this.albumMusics, required this.title});
//   final List<SongModel> albumMusics;
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     // List<SongModel> musics = controller.getAlbumAudio(albumMusics);
//     int adInd = albumMusics.length <= 4 ? albumMusics.length : 4;
//     return Scaffold(
//       floatingActionButton: Floater(),
//       bottomNavigationBar: BannerWidget(),
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//             adManager.loadInterstitialAd();
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         title: Text(title),
//         centerTitle: true,
//       ),
//       body: ListView.separated(
//         padding: EdgeInsets.symmetric(horizontal: 18),
//         itemCount: albumMusics.length + 1,
//         itemBuilder: (_, index) {
//           if (index == adInd) {
//             return NativeAdsWidget(widget: SizedBox.shrink());
//           }
//           SongModel data = albumMusics[getDestinationItemIndex(index)];
//           // String data = musics[index];
//           String title = data.title;
//           return ListTile(
//             onTap: () {
//               // controller.setPlayer(
//               //     filesData: controller.testFunc(musics), initIndex: index);
//             },
//             title: Text(title),
//             leading: QueryArtworkWidget(
//               controller: controller.audioQuery,
//               artworkBorder: BorderRadius.circular(20),
//               id: data.id,
//               type: ArtworkType.AUDIO,
//             ),
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return Divider();
//         },
//       ),
//     );
//   }
// }
