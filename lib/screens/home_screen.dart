import 'package:flutter/material.dart';
import 'package:music_ui/models/category.dart';
import 'package:music_ui/services/category_operations.dart';
import 'package:music_ui/services/music_operations.dart';

import '../models/music.dart';

class Home extends StatelessWidget {
  final Function _miniPlayer;
  const Home(this._miniPlayer, {super.key});
  Widget createCategory(Category category) {
    return Container(
        color: Colors.blueGrey.shade400,
        child: Row(
          children: [
            Image.network(category.imageURL, fit: BoxFit.cover,height: 100,width: 90,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                category.name,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  List<Widget> createListOfCategories() {
    List<Category> categoryList = CategoryOperations.getCategories();
    List<Widget> categories = categoryList
        .map((Category category) => createCategory(category))
        .toList();
    return categories;
  }

  Widget createMusic(Music music) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 200,
              width: 200,
              child: InkWell(
                onTap: (){
                  _miniPlayer(music,stop:true);
                },
                child: Image.network(
                  music.image,
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              music.name,
              style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
          Text(music.desc, style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget createMusicList(String label) {
    List<Music> musicList = MusicOperations.getMusic();
    return Padding(
      padding: const EdgeInsets.only(left: 10,top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return createMusic(musicList[index]);
              },
              itemCount: musicList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget createGrid() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 280,
      child: GridView.count(
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: createListOfCategories(),
      ),
    );
  }

  createAppBar(String message) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(message),

    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blueGrey.shade300, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.1, 0.3])),
            child: Column(
              children: [
                createAppBar('Good morning'),

                createGrid(),
                createMusicList('Made for You'),
                // createMusicList('Popular PlayList')
              ],
            ),
          )),
    );
  }
}