import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';

part 'music_model.g.dart';

@HiveType(typeId: 0)
class MusicModel extends HiveObject implements SongModel {
  @HiveField(0)
  final Uint8List imageList;

  // @HiveField(1)
  // final SongModel songModel;
  @HiveField(1)
  final String imageUri;

  MusicModel({
    required this.album,
    required this.albumId,
    required this.artist,
    required this.artistId,
    required this.bookmark,
    required this.composer,
    required this.data,
    required this.dateAdded,
    required this.dateModified,
    required this.displayName,
    required this.displayNameWOExt,
    required this.duration,
    required this.fileExtension,
    required this.genre,
    required this.genreId,
    required this.getMap,
    required this.id,
    required this.isAlarm,
    required this.isAudioBook,
    required this.isMusic,
    required this.isNotification,
    required this.isPodcast,
    required this.isRingtone,
    required this.size,
    required this.title,
    required this.track,
    required this.uri,
    required this.imageList,
    required this.imageUri,
  });

  @HiveField(2)
  @override
  // TODO: implement album
  final String? album;

  @HiveField(3)
  @override
  // TODO: implement albumId
  final int? albumId;

  @HiveField(4)
  @override
  // TODO: implement artist
  final String? artist;

  @HiveField(5)
  @override
  // TODO: implement artistId
  final int? artistId;

  @HiveField(6)
  @override
  // TODO: implement bookmark
  final int? bookmark;

  @HiveField(7)
  @override
  // TODO: implement composer
  final String? composer;

  @HiveField(8)
  @override
  // TODO: implement data
  final String data;

  @HiveField(9)
  @override
  // TODO: implement dateAdded
  final int? dateAdded;

  @HiveField(10)
  @override
  // TODO: implement dateModified
  final int? dateModified;

  @HiveField(11)
  @override
  // TODO: implement displayName
  final String displayName;

  @HiveField(12)
  @override
  // TODO: implement displayNameWOExt
  final String displayNameWOExt;

  @HiveField(13)
  @override
  // TODO: implement duration
  final int? duration;

  @HiveField(14)
  @override
  // TODO: implement fileExtension
  final String fileExtension;

  @HiveField(15)
  @override
  // TODO: implement genre
  final String? genre;

  @HiveField(16)
  @override
  // TODO: implement genreId
  final int? genreId;

  @HiveField(17)
  @override
  // TODO: implement getMap
  final Map getMap;

  @HiveField(18)
  @override
  // TODO: implement id
  final int id;

  @HiveField(19)
  @override
  // TODO: implement isAlarm
  final bool? isAlarm;

  @HiveField(20)
  @override
  // TODO: implement isAudioBook
  final bool? isAudioBook;

  @HiveField(21)
  @override
  // TODO: implement isMusic
  final bool? isMusic;

  @HiveField(22)
  @override
  // TODO: implement isNotification
  final bool? isNotification;

  @HiveField(23)
  @override
  // TODO: implement isPodcast
  final bool? isPodcast;

  @HiveField(24)
  @override
  // TODO: implement isRingtone
  final bool? isRingtone;

  @HiveField(25)
  @override
  // TODO: implement size
  final int size;

  @HiveField(26)
  @override
  // TODO: implement title
  final String title;

  @HiveField(27)
  @override
  // TODO: implement track
  final int? track;

  @HiveField(28)
  @override
  // TODO: implement uri
  final String? uri;

  factory MusicModel.getData({
    required SongModel songModel,
    required Uint8List imageList,
    required String imageUri,
  }) {
    return MusicModel(
      album: songModel.album,
      albumId: songModel.albumId,
      artist: songModel.artist,
      artistId: songModel.artistId,
      bookmark: songModel.bookmark,
      composer: songModel.composer,
      data: songModel.data,
      dateAdded: songModel.dateAdded,
      dateModified: songModel.dateModified,
      displayName: songModel.displayName,
      displayNameWOExt: songModel.displayNameWOExt,
      duration: songModel.duration,
      fileExtension: songModel.fileExtension,
      genre: songModel.genre,
      genreId: songModel.genreId,
      getMap: songModel.getMap,
      id: songModel.id,
      isAlarm: songModel.isAlarm,
      isAudioBook: songModel.isAudioBook,
      isMusic: songModel.isMusic,
      isNotification: songModel.isNotification,
      isPodcast: songModel.isPodcast,
      isRingtone: songModel.isRingtone,
      size: songModel.size,
      title: songModel.title,
      track: songModel.track,
      uri: songModel.uri,
      imageList: imageList,
      imageUri: imageUri,
    );
  }
}
