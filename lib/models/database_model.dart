import 'dart:io';

import 'package:hive/hive.dart';

import '../constants.dart';

late final BoxCollection collection;
final String modelKel = 'ModelKey';

abstract class HiveSaver {
  static const String musics = 'musics';
  static const String test = 'test';

// static const String musics = 'musics';
  static Future<void> init() async {
    Hive
      ..init(parFolder.path)
      ..registerAdapter(MusicModelAdapter());
    collection = await BoxCollection.open(
      'MyFirstFluffyBox',
      {
        musics,
        test,
      },
      path: parFolder.path,
    );
  }

  static Future<void> saveMusics(List<MusicModel> _) async {
    final musicBox = await collection.openBox(musics);
    var initData = await checkMusic();
    initData == null || initData != _ ? await musicBox.put(modelKel, _) : null;
  }

  static Future<List<MusicModel>?> checkMusic() async {
    final musicBox = await collection.openBox(musics);
    var data = await musicBox.get(modelKel);
    // print('f: ${data.first.runtimeType}');
    return data == null ? null : List<MusicModel>.from(data);
  }
}
