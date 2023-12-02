


import 'package:hive/hive.dart';

part 'favorite_song_model.g.dart';

@HiveType(typeId: 2)
class FavoriteSong extends HiveObject {
  @HiveField(0)
  String songName;

  @HiveField(1)
  String songDescription;

  @HiveField(2)
  bool isFavorite;

  @HiveField(3)
  String audioPath;


  FavoriteSong({
    required this.songName,
    required this.songDescription,
    required this.isFavorite,
    required this.audioPath,
  });

}
