import 'package:flutter/material.dart';
import 'package:mp3_player/album_screen.dart';
import 'package:mp3_player/artist_screen.dart';
import 'package:mp3_player/playlist_screen.dart';
import 'package:mp3_player/songs_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Music'.toUpperCase()),
          bottom:  const TabBar(
            indicatorColor: Colors.grey,
            tabs: [
              Tab(text: 'Songs',),
              Tab(text: 'Artist',),
              Tab(text: 'Album',),
              Tab(text: 'Playlist',),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            SongsScreen(),
            ArtistScreen(),
            AlbumScreen(),
            PlaylistScreen(),
          ],
        ),
      ),
    );
  }
}

