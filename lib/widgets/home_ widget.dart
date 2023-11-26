import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../constants.dart';

class Folders extends GetView<MainController> {
  const Folders({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<String> folders = controller.paths;
      int adInd = folders.length <= 4 ? folders.length : 4;
      return folders.isEmpty
          ? Center(
              child: Text('No musics'),
            )
          : ListView.builder(
              itemCount: folders.length + 1,
              itemBuilder: (_, index) {
                if (index == adInd) {
                  return NativeAdsWidget(widget: SizedBox.shrink());
                }
                String data = folders[getDestinationItemIndex(index)];
                String folderName = data.split('/').last;
                List<MusicModel> folderMusic = controller.getFolderMusics(data);
                return ListTile(
                  onTap: () {
                    // print(
                    //     'testFunc: ${controller.testFunc(folderMusic).length}');
                    Get.to(() => GetMusics(
                          musics: folderMusic,
                          title: folderName,
                        ));
                  },
                  leading: Icon(Icons.folder),
                  title: Text(folderName),
                  subtitle: Subtitle(
                    '${folderMusic.length} Song${folderMusic.length == 1 ? '' : 's'} | ${data.replaceAll(folderName, ' ')}',
                  ),
                );
              });
    });
  }
}

class Subtitle extends StatelessWidget {
  const Subtitle(
    this.data, {
    super.key,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class AllSongs extends GetView<MainController> {
  const AllSongs({super.key});

  @override
  Widget build(BuildContext context) {
    List<MusicModel> musics = musicModels;
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
            });
  }
}

// class MusicIconWidget extends QueryArtworkWidget {
//   const MusicIconWidget(
//       {super.key,
//       // required this.type,
//       // required this.id,
//       // required this.iconData,
//       required super.id,
//       required super.type});
//
//   // final ArtworkType type;
//   // final IconData iconData;
//   // final int id;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Uint8List?>(
//       future: OnAudioQuery().queryArtwork(
//         id,
//         type,
//       ),
//       builder: (_, item) {
//         if (item.data != null && item.data!.isNotEmpty) {
//           return ClipRRect(
//             borderRadius: artworkBorder ?? BorderRadius.circular(10),
//             clipBehavior: artworkClipBehavior,
//             child: Image.memory(
//               item.data!,
//             ),
//           );
//         }
//         return Icon(CupertinoIcons.music_note_2);
//       },
//     );
//   }
// }

class Floater extends GetView<MainController> {
  const Floater({super.key});

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

class Albums extends GetView<MainController> {
  const Albums({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.albumModels.length,
      itemBuilder: (context, index) {
        AlbumModel albumModel = controller.albumModels[index];
        List<MusicModel> albumMusics = controller.getAlbumAudio(albumModel);
        return ListTile(
          title: Text(albumModel.album),
          subtitle: Subtitle(
            '${albumModel.numOfSongs} songs | ${albumModel.artist}',
          ),
          onTap: () async {
            print('Album Musics: ${albumMusics.length}');
            Get.to(() => GetMusics(
                  musics: albumMusics,
                  title: albumModel.album,
                ));
          },
          leading: QueryArtworkWidget(
            id: albumModel.id,
            type: ArtworkType.ALBUM,
            nullArtworkWidget: Icon(
              Icons.album,
              size: 50,
            ),
          ),
        );
      },
    );
  }
}

class Artists extends GetView<MainController> {
  const Artists({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.artistModels.length,
      itemBuilder: (context, index) {
        ArtistModel artistModel = controller.artistModels[index];
        List<MusicModel> albumMusics = controller.getArtistAudio(artistModel);
        return ListTile(
          title: Text(artistModel.artist),
          subtitle: Subtitle(
            '${artistModel.numberOfTracks} tracks | ${artistModel.artist}',
          ),
          onTap: () async {
            print('Album Musics: ${albumMusics.length}');
            Get.to(() => GetMusics(
              musics: albumMusics,
              title: artistModel.artist,
            ));
          },
          leading: QueryArtworkWidget(
            id: artistModel.id,
            type: ArtworkType.ARTIST,
            nullArtworkWidget: Image.asset(
              'assets/artist.png',
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

