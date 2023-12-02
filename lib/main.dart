import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mp3_player/db/audio_model.dart';
import 'package:mp3_player/db/favorite_song_model.dart';
import 'package:mp3_player/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/adapters.dart';
import 'db/audio_box.dart';
late final SharedPreferences preferences;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();  //Initialized HIVE DB
  Hive.registerAdapter(AudioModelAdapter()); /// Registered Adapters
  Hive.registerAdapter(FavoriteSongAdapter());/// Registered Adapters
  audioBox = await Hive.openBox('songsBox');
  favoriteBox = await Hive.openBox('favoriteSongsBox');
  preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: false,
          ),
          home: child,
        );
      },
      child: const SplashScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   List<SongModel> songList = [];
//   List<SongModel> folderList = [];
//   List<String> pathList = [];
//   List<String> folderNameList = [];
//   final _audioQuery = OnAudioQuery();
//   final audioPlayer = AudioPlayer();
//
//   @override
//   void initState() {
//     super.initState();
//     _initPermissions();
//   }
//
//
//   playSong(String? uri)async{
//     try{
//       audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
//       await audioPlayer.play();
//     }on Exception catch (e){
//       print(e.toString());
//     }
//   }
//
//   void _initPermissions() async{
//     if(!await Permission.manageExternalStorage.request().isGranted){
//       await Permission.manageExternalStorage.request();
//     }else {
//       try{
//         _audioQuery.permissionsRequest().whenComplete(() async{
//           print('permissions granted');
//           _audioQuery.querySongs(
//             uriType: UriType.EXTERNAL,
//           ).then((value) {
//             print('audioList: ${value.toList().first}');
//             setState(() {
//               songList = value.toList();
//             });
//           });
//           pathList = await _audioQuery.queryAllPath();
//           for(var element in pathList){
//             String lastWord = extractLastWord(element);
//             folderNameList.add(lastWord);
//             folderList = await _audioQuery.querySongs(path: element);
//             print('folderName: ${lastWord}');
//             print('foldersSongs: $folderList');
//           }
//           print('folderNameList: $folderNameList');
//            print('pathList: $pathList}');
//         });
//
//          // print('_audioQuery: ${_audioQuery.queryAllPath()}');
//       }catch (e){
//         print('exception: ${e.toString()}');
//       }
//
//     }
//   }
//
//   String extractLastWord(String text) {
//     // Split the text by '/' to get segments
//     List<String> segments = text.split('/');
//
//     // Filter out empty segments (e.g., if there are multiple '/' characters)
//     List<String> nonEmptySegments = segments.where((segment) => segment.isNotEmpty).toList();
//
//     // Check if there are any segments
//     if (nonEmptySegments.isNotEmpty) {
//       // Return the last segment, which is the last word in this context
//       return nonEmptySegments.last;
//     } else {
//       // If there are no non-empty segments, return an empty string
//       return '';
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//             songList.isNotEmpty ? Expanded(
//               child: ListView.builder(
//                 itemCount: songList.length,
//                   itemBuilder: (context, index){
//                     return ListTile(
//                       onTap: (){
//                         print("SongPath ${songList[index].uri}");
//                         playSong(songList[index].uri);
//                       },
//                       title: Text(songList[index].displayName),
//                       subtitle: Text(songList[index].album.toString()),
//                     );
//                   }),
//             ) : const Center(child: CircularProgressIndicator(),),
//           ],
//         ),
//       ),
//
//     );
//   }
// }
