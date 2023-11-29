import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/music.dart';
import '../services/music_operations.dart';

class LibraryMusicScreen extends StatefulWidget {
  @override
  _LibraryMusicScreenState createState() {
    return _LibraryMusicScreenState();
  }
}

class _LibraryMusicScreenState extends State<LibraryMusicScreen> {
  List<Music> musicList = MusicOperations.getMusic();
  List<dynamic> _foundMusic = [];
  bool _isPlaying = false;
  AudioPlayer _audioPlayer = new AudioPlayer();
  @override
  void initState() {
    super.initState();
    _foundMusic = musicList;

  }

  void _playPause(String audioUrl, dynamic music) {

    if (music.isPlaying ==true) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(audioUrl));
    }


    setState(() {
      music.isPlaying =!music.isPlaying;
    });

  }


  @override
  void dispose() {
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = musicList;
    } else {
      results = musicList
          .where((music) =>
          music.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundMusic = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Your Library',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          children: [
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: _foundMusic.length,
                  itemBuilder: (context, index) => Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(_foundMusic[index].image),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(_foundMusic[index].name),
                      subtitle: Text('${_foundMusic[index].desc}'),
                      onTap: () => _playPause(_foundMusic[index].audioURL,_foundMusic[index]),
                      trailing: IconButton(
                        icon: Icon(_foundMusic[index].isPlaying  ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          _playPause(_foundMusic[index].audioURL,_foundMusic[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMusic(Music music) => ListTile(
    leading: Image.network(
      music.image,
      fit: BoxFit.cover,
      width: 80,
      height: 80,
    ),
    title: Text(music.name),
    subtitle: Text(music.desc),
  );
}