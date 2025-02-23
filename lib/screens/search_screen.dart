import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../constants.dart';

//
// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});
//
//   @override
//   SearchPageState createState() => SearchPageState();
// }
//
// class SearchPageState extends State<SearchPage> {
//   String? _result;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: const BannerWidget(),
//       appBar: AppBar(title: const Text('Search')),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Text(_result ?? '', style: const TextStyle(fontSize: 18)),
//             ElevatedButton(
//               onPressed: () async {
//                 var result = await showSearch<String>(
//                   context: context,
//                   delegate: CustomDelegate(),
//                 );
//                 setState(() => _result = result);
//               },
//               child: const Text('Search'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomDelegate extends SearchDelegate<String> {
  MainController controller = Get.find<MainController>();

  // List<String> data = controller.surahNames;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () {
        adManager.loadInterstitialAd();
        close(context, '');
      });

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<SongModel> listToShow;
    if (query.isNotEmpty) {
      listToShow = songModels.where((SongModel e) {
        bool search = e.title
            .contains(RegExp(query.replaceAll(' ', '-'), caseSensitive: false));
        return search;
      }).toList();
    } else {
      listToShow = songModels;
    }
    // && e.toLowerCase().startsWith(query)
    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        SongModel dataItem = listToShow[i];
        return ListTile(
          onTap: () {
            // controller.setPlayer(
            //   filesData: controller.allMusicData,
            //   initIndex: controller.allMusicData.indexOf(dataItem),
            // );
          },
          // leading: MusicIconWidget(
          //   iconData: CupertinoIcons.music_note_2,
          //   type: ArtworkType.AUDIO,
          //   id: dataItem.id,
          // ),
          title: Text(dataItem.title),
        );
        // var noun = listToShow[i];
        // return ListTile(
        //   title: Text(noun),
        //   onTap: () => close(context, noun),
        // );
      },
    );
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      toLowerCase().contains(secondString.toLowerCase());

//bool isNotBlank() => this != null && this.isNotEmpty;
}
