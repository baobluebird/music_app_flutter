import '../models/music.dart';

class MusicOperations {
  MusicOperations._() {}
  static List<Music> getMusic() {
    return <Music>[
      Music(
          'Chìm sâu',
          'https://i.ytimg.com/vi/Yw9Ra2UiVLw/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGBwgLih_MA8=&rs=AOn4CLAMWj_2GQAyiwpo8LzFqy1CyQtPPA',
          'MCK ft Trung Trần',
          'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/c9/72/b4/c972b48a-f537-6fa4-f765-2090618e0010/mzaf_4740214827391316359.plus.aac.p.m4a',
          false
      ),
      Music(
          'Save Your Tears',
          'https://m.media-amazon.com/images/M/MV5BZGIxMTAwZjctNmFkMC00MWI3LTlhODItMDlkMjA0N2U1YjAzXkEyXkFqcGdeQXVyNDU1NDIzMzY@._V1_.jpg',
          'The Weeknd',
          'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/76/f0/42/76f042a2-ec4a-03df-c3c4-bfd2e1971b3f/mzaf_3250400076320409439.plus.aac.p.m4a',
          false
      ),
      Music(
          'Unti I Found You ',
          'https://i.scdn.co/image/ab67616d0000b273eabddae72a3b1a5ed51d1ac6',
          'Stephen Sanchez',
          'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/80/8f/f8/808ff834-df71-6af6-e353-b5ddff95e09d/mzaf_9538645391579026425.plus.aac.p.m4a',
          false
      ),
      Music(
          'Birds In The Trap Sing McKnight',
          'https://upload.wikimedia.org/wikipedia/en/6/61/Travis_Scott_-_Birds_in_the_Trap_Sing_McKnight.png',
          'Travis Scott',
          'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/71/ee/c0/71eec000-5864-7390-bf13-174d977e3bc1/mzaf_5835469423921585229.plus.aac.p.m4a',
          false
      )
    ];
  }
}