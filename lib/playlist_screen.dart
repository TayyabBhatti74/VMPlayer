import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_player/db/favorite_song_model.dart';
import 'package:mp3_player/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'db/audio_box.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {


  bool audioIsPlaying = false;
  int currentlyPlayingIndex = -1;
  bool isFavorite = false;
  int currentItemIndex = 0;
  final _audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  List<Map<String, dynamic>> songList = [];

  playSong(String? uri)async{
    try{
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      await audioPlayer.play();
    }on Exception catch (e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    var favoriteSongs = favoriteBox.values.toList(); // Assuming 'favoriteBox' contains 'FavoriteSong' objects
     songList = favoriteSongs.map((song) {
      print('songName: ${song.songName}');
      return {
        "songName": song.songName,
        "songDescription": song.songDescription,
        "isFavorite": song.isFavorite,
        "audioPath": song.audioPath,
      };
    }).toList();
    print('favoriteSongs: $songList');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index){
                  final isCurrentlyPlaying = index == currentlyPlayingIndex;
                  // var currentBox = box.getAt(index);
                  // print('currentBox: ${currentBox['isFavorite']}');
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(songList[index]['songName'], overflow: TextOverflow.ellipsis,
                                maxLines: 2,),
                              Text(songList[index]['songDescription'] ?? ''),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (isCurrentlyPlaying) {
                                  setState(() {
                                    currentlyPlayingIndex = -1; // Reset to -1 to indicate no audio is playing
                                  });
                                  await audioPlayer.pause();
                                } else {
                                  print('audioPath: ${songList[index]['audioPath']}');
                                  playSong(songList[index]['audioPath']);
                                  setState(() {
                                    currentlyPlayingIndex = index; // Update the currently playing index
                                  });
                                }
                              },
                              child: isCurrentlyPlaying
                                  ? Icon(Icons.pause_circle, size: 35.r, color: Colors.green,)
                                  : Icon(Icons.play_circle, size: 35.r, color: Colors.deepPurple,),
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Material(
                                color: Colors.transparent,
                                child: IconButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.grey)
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        isFavorite = !isFavorite; // Toggle the favorite state
                                      });

                                      // CustomSongModel model = CustomSongModel(
                                      //     title: songList[index].title ?? '',
                                      //     artistName: songList[index].artist ?? '',
                                      //     isFavorite: isFavorite,
                                      //     audioPath: songList[index].uri
                                      // );

                                      // addToFavoriteSongs(index,model);
                                      // refreshItems();
                                    },
                                    icon: Icon(songList[index]['isFavorite'] ? Icons.favorite : Icons.favorite_outline_rounded, )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
