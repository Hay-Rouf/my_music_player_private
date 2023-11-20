import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../constants.dart';

class Folders extends GetView<MainController> {
  const Folders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<String> musics = controller.musicsFolder;
      int adInd = musics.length <= 4 ? musics.length : 4;
      return musics.isEmpty
          ? Center(
              child: Text('No musics'),
            )
          : ListView.builder(
              itemCount: musics.length + 1,
              itemBuilder: (_, index) {
                if (index == adInd) {
                  return NativeAdsWidget(widget: SizedBox.shrink());
                }
                String data = musics[getDestinationItemIndex(index)];
                String folderName = data.split('/').last;
                List<String> folderMusic = controller.getFolderMusics(data);
                return ListTile(
                  onTap: () {
                    print(
                        'testFunc: ${controller.testFunc(folderMusic).length}');
                    Get.to(() => FolderMusics(
                          dir: data,
                          title: folderName,
                        ));
                  },
                  leading: Icon(Icons.folder),
                  title: Text(folderName),
                  subtitle: Text(
                    '${folderMusic.length} songs | ${data.replaceAll(folderName, ' ')}',
                  ),
                );
              });
    });
  }
}

class AllSongs extends GetView<MainController> {
  const AllSongs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AudioModel> musics = controller.allMusicData;
    int adInd = musics.length <= 4 ? musics.length : 4;
    return musics.isEmpty
        ? Center(
            child: Text('No musics'),
          )
        : ListView.separated(
            separatorBuilder: (_, index) {
              return Divider();
            },
            itemCount: musics.length + 1,
            itemBuilder: (_, index) {
              if (index == adInd) {
                return NativeAdsWidget(widget: SizedBox.shrink());
              }
              AudioModel data = musics[getDestinationItemIndex(index)];
              String folderName = data.id;
              return ListTile(
                onTap: () {
                  controller.setPlayer(filesData: musics, initIndex: index);
                  // controller.setChildren(
                  //     currentFile: data.path,
                  //     filesData: musics.map((e) => e.path).toList());
                },
                leading: Icon(Icons.music_note),
                title: Text(folderName),
                // subtitle: Text(
                //   '${folderMusic.length} songs | ${data.replaceAll(folderName, ' ')}',
                // ),
              );
            });
  }
}

class Floater extends GetView<MainController> {
  const Floater({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: controller.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        print('processingState: $processingState, playing: $playing');
        if (processingState == ProcessingState.ready && playing == false) {
          return FloatingActionButton(
            backgroundColor: myBlue,
            onPressed: () {
              Get.toNamed(PlayerScreen.id);
            },
            child: const Icon(
              CupertinoIcons.music_note_2,
              color: myWhite,
            ),
          );
        } else if (processingState == ProcessingState.ready &&
            playing == true) {
          return FloatingActionButton(
            backgroundColor: myBlue,
            onPressed: () {
              Get.toNamed(PlayerScreen.id);
            },
            child: Stack(
              alignment: Alignment.center,
              children: const [
                SpinKitRipple(
                  color: myWhite,
                  duration: Duration(seconds: 3),
                ),
                Icon(
                  CupertinoIcons.music_note_2,
                  color: myWhite,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

//   ListTile(
//   onTap: () {
//     // controller.getMetadata(data);
//     controller.setChildren(currentFile: data, filesData: musics);
//     Get.to(() => PlayerScreen());
//   },
//   leading: FutureBuilder(
//       future: controller.getMusicData(data),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//         // print('art: ${snapshot.data!.albumArt?.length}');
//         return snapshot.data!.albumArt == null
//             ? Icon(Icons.music_note)
//             : Image.memory(
//                 snapshot.data!.albumArt!,
//                 height: 40,
//                 // width: 40,
//               );
//         }
//         print('error: ${snapshot.hasData}');
//         return Center(child: Icon(Icons.music_note),);
//       }),
//   // FutureBuilder(
//   //     future: controller.getMusicData(data),
//   //     builder: (context, snapshot) {
//   //       if (snapshot.hasData) {
//   //         // print('art: ${snapshot.data!.albumArt}');
//   //         snapshot.data!.albumArt == null
//   //             ? Icon(Icons.music_note)
//   //             : Image.memory(snapshot.data!.albumArt!,height: 40,width: 40,);
//   //       }
//   //       return Center(child: CircularProgressIndicator(),);
//   //     }),
//   title: Text(folderName.replaceAll('.mp3', '')),
//   // subtitle: Divider(),
// );
