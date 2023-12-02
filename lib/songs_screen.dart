import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mp3_player/db/audio_box.dart';
import 'package:mp3_player/db/favorite_song_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';



class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {

  List<SongModel> songList = [];
  List<SongModel> folderList = [];
  List<String> pathList = [];
  List<String> folderNameList = [];
  List<Map<String, dynamic>> appSongList = [];
  bool audioIsPlaying = false;
  int currentlyPlayingIndex = -1;
  bool isFavorite = false;
  int currentItemIndex = 0;
  final _audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  late PlayerState playerState;
  List<CustomSongModel> favoriteSongs = [];
  int counter = 0;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream, (position, bufferPosition, duration) =>
          PositionData(position, bufferPosition, duration ?? Duration.zero)
      );

  @override
  void initState() {
    super.initState();
    // favoriteBox.clear();
    // audioBox.clear();
    _initPermissions();
  }

  playSong(String? uri)async{
    try{
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      // Listen to the player position stream to get updates on playback progress
      audioPlayer.playerStateStream.listen((PlayerState state) {
        // Handle the playback position updates here
        setState(() {
          playerState = state;
        });
        print('Current position: $state');



      });
      await audioPlayer.play();

    }on Exception catch (e){
      print(e.toString());
    }
  }

  void _initPermissions() async{
    if(!await Permission.manageExternalStorage.isGranted){
      await Permission.manageExternalStorage.request().isGranted.whenComplete(() {
        try{
          CustomSongModel customSongModel = CustomSongModel();
          _audioQuery.permissionsRequest().whenComplete(() async{
            print('permissions granted');
            _audioQuery.querySongs(
              uriType: UriType.EXTERNAL,
            ).then((value) {
              // print('audioList: ${value.toList().first}');
              setState(() {
                songList = value.toList();
                for(var songs in songList){
                  print('songs: ${songs.data}');
                  customSongModel = CustomSongModel(
                      title: songs.displayNameWOExt,
                      artistName: songs.artist.toString(),
                      audioPath: songs.data,
                      isFavorite: false);
                  Map<String, dynamic> audioMap = {
                    'title': customSongModel.title,
                    'artistName': customSongModel.artistName,
                    'isFavorite': customSongModel.isFavorite,
                    'audioPath': customSongModel.audioPath,
                  };
                  print('audioMap: $audioMap');
                  if(!audioBox.values.contains(customSongModel)){
                    print('song not yet added');
                    setState(() {
                      audioBox.add(audioMap);
                      refreshItems();
                    });

                  }else {
                    print('song already added');
                  }
                }

                // print('myList: ${audioBox.keys.map((key) {
                //   var value = audioBox.get(key);
                //   // print('audioValue: ${value}');
                //   return {
                //     "key": key,
                //     "title": value['title'],
                //     "artistName": value['artistName'],
                //     "isFavorite": value['isFavorite'],
                //     "audioPath": value['audioPath'],
                //   };
                // }).toList()}');
              });
            });
            pathList = await _audioQuery.queryAllPath();
            for(var element in pathList){
              String lastWord = extractLastWord(element);
              folderNameList.add(lastWord);
              folderList = await _audioQuery.querySongs(path: element);
              // print('folderName: ${lastWord}');
              // print('foldersSongs: $folderList');
            }
            // print('folderNameList: $folderNameList');
            // print('pathList: $pathList}');
          });

          // print('_audioQuery: ${_audioQuery.queryAllPath()}');
        }catch (e){
          print('exception: ${e.toString()}');
        }
      });
    }else {
      try{
        CustomSongModel customSongModel = CustomSongModel();
        _audioQuery.permissionsRequest().whenComplete(() async{
          print('permissions granted');
          _audioQuery.querySongs(
            uriType: UriType.EXTERNAL,
          ).then((value) {
            // print('audioList: ${value}');
            setState(() {
              songList = value.toList();
              for(var songs in songList){
                print('songsElse: ${songs.data}');
                customSongModel = CustomSongModel(
                    title: songs.displayNameWOExt,
                  artistName: songs.artist,
                  audioPath: songs.data,
                  isFavorite: false);

                Map<String, dynamic> audioMap = {
                  'title': customSongModel.title,
                  'artistName': customSongModel.artistName,
                  'isFavorite': customSongModel.isFavorite,
                  'audioPath': customSongModel.audioPath,
                };
                print('audioMap: $audioMap');
                if(!audioBox.values.contains(customSongModel)){
                  print('song not yet added');
                  setState(() {
                    audioBox.add(audioMap);
                  });
                }else {
                  print('song already added');
                }

              }
              print('myList: ${audioBox.keys.map((key) {
                var value = audioBox.get(key);
                // print('audioValue: ${value}');
                return {
                  "key": key,
                  "title": value['title'],
                  "artistName": value['artistName'],
                  "isFavorite": value['isFavorite'],
                  "audioPath": value['audioPath'],
                };
              }).toList()}');
            });
          });
          pathList = await _audioQuery.queryAllPath();
          for(var element in pathList){
            String lastWord = extractLastWord(element);
            folderNameList.add(lastWord);
            folderList = await _audioQuery.querySongs(path: element);
            // print('folderName: ${lastWord}');
            // print('foldersSongs: $folderList');
          }
          // print('folderNameList: $folderNameList');
          // print('pathList: $pathList}');
        });

        // print('_audioQuery: ${_audioQuery.queryAllPath()}');
      }catch (e){
        print('exception: ${e.toString()}');
      }

    }
  }

  String extractLastWord(String text) {
    // Split the text by '/' to get segments
    List<String> segments = text.split('/');

    // Filter out empty segments (e.g., if there are multiple '/' characters)
    List<String> nonEmptySegments = segments.where((segment) => segment.isNotEmpty).toList();

    // Check if there are any segments
    if (nonEmptySegments.isNotEmpty) {
      // Return the last segment, which is the last word in this context
      return nonEmptySegments.last;
    } else {
      // If there are no non-empty segments, return an empty string
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          songList.isNotEmpty ? Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: appSongList.length,
              itemBuilder: (context, index) {
                final isCurrentlyPlaying = index == currentlyPlayingIndex;
                // var currentBox = box.getAt(index);
                print('currentBox: ${appSongList[index]['audioPath'].toString()}');
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
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appSongList[index]['title'], overflow: TextOverflow.ellipsis,
                                maxLines: 2,),
                              Text(appSongList[index]['artistName'].toString()),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: () async{
                              print('audioPath: ${appSongList[index]['audioPath']}');
                              await Share.shareFiles([appSongList[index]['audioPath'].toString()]);
                            }, icon: const Icon(Icons.share)),
                            GestureDetector(
                              onTap: () async {
                                if (isCurrentlyPlaying) {
                                  setState(() {
                                    currentlyPlayingIndex = -1; // Reset to -1 to indicate no audio is playing
                                  });
                                  await audioPlayer.pause();
                                } else {
                                  print('audioPath: ${appSongList[index]['audioPath']}');
                                  playSong(appSongList[index]['audioPath']);
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
                                    style: const ButtonStyle(
                                        backgroundColor: MaterialStatePropertyAll(Colors.grey)
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        isFavorite = !isFavorite; // Toggle the favorite state
                                      });
                                      CustomSongModel customModel = CustomSongModel(
                                          title: songList[index].title ?? '',
                                          artistName: songList[index].artist ?? '',
                                          isFavorite: true,
                                          audioPath: songList[index].data ?? ''
                                      );
                                      FavoriteSong model = FavoriteSong(
                                          songName: songList[index].title ?? '',
                                          songDescription: songList[index].artist ?? '',
                                          isFavorite: true,
                                          audioPath: songList[index].data ?? ''
                                      );
                                      saveToDb(index, customModel);
                                      addToFavoriteSongs(model);
                                      refreshItems();
                                    },
                                    icon: Icon(appSongList[index]['isFavorite'] ? Icons.favorite : Icons.favorite_outline_rounded, )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ) : const Expanded(child: Center(child: CircularProgressIndicator(),)),

          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            child: Column(
              children: [
               StreamBuilder<PositionData>(
                   stream: _positionDataStream,
                   builder: (context, snapshot){
                     final positionData = snapshot.data;
                     return Column(
                       children: [
                         ProgressBar(
                             progress: positionData?.position ?? Duration.zero,
                             buffered: positionData?.bufferPosition ?? Duration.zero,
                             total: positionData?.duration ?? Duration.zero,
                           onSeek: audioPlayer.seek,
                         ),
                       ],
                     );
                   }),
                StreamBuilder<PlayerState>(
                    stream: audioPlayer.playerStateStream,
                    builder: (context, snapshot){
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing ?? false;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              counter = counter + 2;
                              print('counter: $counter');
                              // Implement functionality for the back button
                            },
                            icon: const Icon(Icons.skip_previous, size: 30,),
                          ),

                          if(!playing)
                            IconButton(
                              onPressed: audioPlayer.play,
                              icon: const Icon(Icons.play_circle, size: 35),
                            )
                          else if(processingState != ProcessingState.completed)
                            IconButton(
                              onPressed: audioPlayer.pause,
                              icon: const Icon(Icons.pause_rounded, size: 35),
                            ),

                          IconButton(
                            onPressed: () {
                              // Implement functionality for the next button
                            },
                            icon: const Icon(Icons.skip_next, size: 30),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  void addToFavoriteSongs(FavoriteSong audioModel) async {
    print('favorite called');

    // favoriteBox = await Hive.openBox('favoriteSongsBox'); // Open the Hive box if not already opened
    // Check if the song is already in the favorites list
    if (!favoriteBox.values.contains(audioModel)) {
      print('song added');
      await favoriteBox.add(audioModel); // Save the song to the 'favoriteSongsBox' Hive box
      refreshItems();
    }else {
      print('song already added');
    }

    // await favoriteBox.close(); // Close the box when done (or do it in your widget's dispose method)

    // Refresh your UI or update any other relevant logic
    // Note: You don't need to call setState here since Hive is asynchronous
  }

// Update a single item

  Future<void> saveToDb(int itemKey, CustomSongModel model) async {

    Map<String, dynamic> imageMap = {
      'key': itemKey,
      'title': model.title,
      'artistName': model.artistName,
      'isFavorite': model.isFavorite,
      'audioPath': model.audioPath,
    };
    if (!audioBox.values.contains(model)) {
      await audioBox.putAt(itemKey, imageMap); // Save the song to the 'favoriteSongsBox' Hive box
      refreshItems();
    }

    refreshItems(); // Update the UI
  }

  Future<void> refreshItems() async {

   appSongList = audioBox.keys.map((key) {
      var value = audioBox.get(key);
      print('audioValue: ${value}');
      return {
        "key": key,
        "title": value['title'],
        "artistName": value['artistName'],
        "isFavorite": value['isFavorite'],
        "audioPath": value['audioPath'],
      };
    }).toList();
    // print('audioSong: ${audioBox.length}');

    var favoriteSongs = favoriteBox.values.toList(); // Assuming 'favoriteBox' contains 'FavoriteSong' objects
    List<Map<String, dynamic>> songList = favoriteSongs.map((song) {
      print('songName: ${song.songName}');
      return {
        "songName": song.songName,
        "songDescription": song.songDescription,
        "isFavorite": song.isFavorite,
        "audioPath": song.audioPath,
      };
    }).toList();
    print('favoriteSongs: $songList');
    setState(() {

    });
  }

}

class PositionData{
  final Duration position;
  final Duration bufferPosition;
  final Duration duration;

  const PositionData(this.position, this.bufferPosition, this.duration);

}

class CustomSongModel {
  String? title;
  String? artistName;
  String? audioPath;
  bool? isFavorite;
  CustomSongModel({this.title, this.artistName, this.audioPath, this.isFavorite});
}