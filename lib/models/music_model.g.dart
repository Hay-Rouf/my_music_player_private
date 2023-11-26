// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusicModelAdapter extends TypeAdapter<MusicModel> {
  @override
  final int typeId = 0;

  @override
  MusicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MusicModel(
      album: fields[2] as String?,
      albumId: fields[3] as int?,
      artist: fields[4] as String?,
      artistId: fields[5] as int?,
      bookmark: fields[6] as int?,
      composer: fields[7] as String?,
      data: fields[8] as String,
      dateAdded: fields[9] as int?,
      dateModified: fields[10] as int?,
      displayName: fields[11] as String,
      displayNameWOExt: fields[12] as String,
      duration: fields[13] as int?,
      fileExtension: fields[14] as String,
      genre: fields[15] as String?,
      genreId: fields[16] as int?,
      getMap: (fields[17] as Map).cast<dynamic, dynamic>(),
      id: fields[18] as int,
      isAlarm: fields[19] as bool?,
      isAudioBook: fields[20] as bool?,
      isMusic: fields[21] as bool?,
      isNotification: fields[22] as bool?,
      isPodcast: fields[23] as bool?,
      isRingtone: fields[24] as bool?,
      size: fields[25] as int,
      title: fields[26] as String,
      track: fields[27] as int?,
      uri: fields[28] as String?,
      imageList: fields[0] as Uint8List,
      imageUri: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MusicModel obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.imageList)
      ..writeByte(1)
      ..write(obj.imageUri)
      ..writeByte(2)
      ..write(obj.album)
      ..writeByte(3)
      ..write(obj.albumId)
      ..writeByte(4)
      ..write(obj.artist)
      ..writeByte(5)
      ..write(obj.artistId)
      ..writeByte(6)
      ..write(obj.bookmark)
      ..writeByte(7)
      ..write(obj.composer)
      ..writeByte(8)
      ..write(obj.data)
      ..writeByte(9)
      ..write(obj.dateAdded)
      ..writeByte(10)
      ..write(obj.dateModified)
      ..writeByte(11)
      ..write(obj.displayName)
      ..writeByte(12)
      ..write(obj.displayNameWOExt)
      ..writeByte(13)
      ..write(obj.duration)
      ..writeByte(14)
      ..write(obj.fileExtension)
      ..writeByte(15)
      ..write(obj.genre)
      ..writeByte(16)
      ..write(obj.genreId)
      ..writeByte(17)
      ..write(obj.getMap)
      ..writeByte(18)
      ..write(obj.id)
      ..writeByte(19)
      ..write(obj.isAlarm)
      ..writeByte(20)
      ..write(obj.isAudioBook)
      ..writeByte(21)
      ..write(obj.isMusic)
      ..writeByte(22)
      ..write(obj.isNotification)
      ..writeByte(23)
      ..write(obj.isPodcast)
      ..writeByte(24)
      ..write(obj.isRingtone)
      ..writeByte(25)
      ..write(obj.size)
      ..writeByte(26)
      ..write(obj.title)
      ..writeByte(27)
      ..write(obj.track)
      ..writeByte(28)
      ..write(obj.uri);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
