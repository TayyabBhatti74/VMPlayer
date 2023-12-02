
import 'package:hive/hive.dart';

part 'audio_model.g.dart';

@HiveType(typeId: 1)
class AudioModel extends HiveObject {
  @HiveField(0)
  String songName;

  @HiveField(2)
  String songDescription;

  @HiveField(3)
  bool isFavorite;


  AudioModel({
    required this.songName,
    required this.songDescription,
    required this.isFavorite,
  });

}
