import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_ui/screens/yourlibarary.dart';
import 'package:music_ui/screens/search.dart';
import 'package:music_ui/models/music.dart';
import 'package:music_ui/services/login_service.dart';
import 'package:music_ui/services/music_operations.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import 'login.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  List<Music> musicList = MusicOperations.getMusic();
  final AudioPlayer _audioPlayer = AudioPlayer();

  final myBox = Hive.box('myBox');
  late String storedToken;
  String serverMessage = '';
  String nameUser = '';
  String idUser = '';



  Future<void> clearHiveBox(String boxName) async {
    var box = await Hive.openBox(boxName);
    await box.clear();
  }

  Future<void> _logout(String token) async {
    try {
      final Map<String, dynamic> response = await LogoutService.logout(token);

      print('Response status: ${response['status']}');
      print('Response body: ${response['message']}');
      if (response['status'] == "success" && mounted) {
        setState(() {
          serverMessage = response['message'];
        });
        print('Logout successful');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        print(serverMessage);
      } else if (mounted) {
        setState(() {
          serverMessage = response['message'];
        });
        print('Login failed: ${response['message']}');
        print(serverMessage);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          serverMessage = 'Error: $error';
        });
        print('Error: $error');
        print(serverMessage);
      }
    }
  }

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    nameUser = myBox.get('name', defaultValue: '');
    idUser = myBox.get('id', defaultValue: '');

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    Tabs = [Home(miniPlayer), Search(), Yourlibrary()];
  }

  var Tabs = [];
  int currentTabIndex = 0;
  int currentSong = 0;
  bool isPlaying = false;
  Music? music;

  Widget miniPlayer(Music? music, {bool stop = false}) {
    this.music = music;

    if (music == null) {
      return const SizedBox();
    }
    if (stop) {
      isPlaying = false;
      _audioPlayer.stop();
    }
    setState(() {});
    Size deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.black45,
      width: deviceSize.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(music.image, fit: BoxFit.cover)),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: 180,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          music.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Center(
                        child: Text(
                          music.desc,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await _audioPlayer
                        .play(UrlSource(musicList[currentSong - 1].audioURL));
                    currentSong--;
                    if (currentSong < 0) {
                      currentSong = 0;
                    }
                    setState(() {
                      this.music = musicList[currentSong];
                    });
                  },
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        await _audioPlayer.play(UrlSource(music.audioURL));
                      } else {
                        await _audioPlayer.pause();
                      }
                      setState(() {});
                    },
                    icon: isPlaying
                        ? const Icon(Icons.pause, color: Colors.white)
                        : const Icon(Icons.play_arrow, color: Colors.white)),
                IconButton(
                  onPressed: () async {
                    await _audioPlayer
                        .play(UrlSource(musicList[currentSong + 1].audioURL));
                    currentSong++;
                    // if(currentSong > musicList.length-1){
                    //   currentSong = 0;
                    // }
                    setState(() {
                      this.music = musicList[currentSong];
                    });
                  },
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.white,
                trackShape: const RectangularSliderTrackShape(),
                trackHeight: 4.0,
                thumbColor: Colors.white,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayColor: Colors.red.withAlpha(32),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 28.0),
              ),
              child: Slider(
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(position.inSeconds),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(formatTime((position - duration).inSeconds),
                      style: const TextStyle(color: Colors.white))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.blueGrey.shade400,
            child: ListView(
              children: [
                ListTile(
                  title: Text(nameUser),
                  textColor: Colors.black,
                  leading: const Icon(
                    Icons.account_circle,
                  ),
                  onTap: () {
                    print('Name: $nameUser');
                  },
                ),
                ListTile(
                  title: const Text('Change Password'),
                  textColor: Colors.black,
                  leading: const Icon(
                    Icons.account_circle,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Log out'),
                  leading: const Icon(
                    Icons.logout,
                  ),
                  onTap: () {
                    storedToken = myBox.get('token', defaultValue: '');
                    if (storedToken != '') {
                      _logout(storedToken);
                      clearHiveBox('myBox');
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Log out successfully!"),
                        duration: Duration(seconds: 1),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          body: Tabs[currentTabIndex],
          backgroundColor: Colors.black,
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              miniPlayer(music),
              BottomNavigationBar(
                currentIndex: currentTabIndex,
                onTap: (currentIndex) {
                  print("Current Index is $currentIndex");
                  currentTabIndex = currentIndex;
                  setState(() {}); // re-render
                },
                selectedLabelStyle: const TextStyle(color: Colors.white),
                selectedItemColor: Colors.white,
                backgroundColor: Colors.black45,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home, color: Colors.white),
                      label: 'Home'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search, color: Colors.white),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.library_books, color: Colors.white),
                      label: 'Your Library')
                ],
              )
            ],
          ),
        ));
  }
}
