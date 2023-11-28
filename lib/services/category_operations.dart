

import '../models/category.dart';

class CategoryOperations {
  CategoryOperations._();
  static List<Category> getCategories() {
    return <Category>[
      Category(
        'Top Songs',
        'https://upload.wikimedia.org/wikipedia/commons/b/b5/191125_Taylor_Swift_at_the_2019_American_Music_Awards_%28cropped%29.png',
      ),
      Category(
        'The Weekend',
        'https://lastfm.freetls.fastly.net/i/u/ar0/1744ee11ac012ab6e54f9b2b613a5531.jpg',
      ),
      Category(
        'BlackPink',
        'https://images2.thanhnien.vn/528068263637045248/2023/6/26/bp1-16877727885561833055507.jpeg',
      ),
      Category(
        'Doja Cat',
        'https://kenh14cdn.com/thumb_w/660/203336854389633024/2023/7/27/photo-1-16904221754091084077710.jpg',
      ),
      Category(
        'CardiB',
        'https://cdn.britannica.com/85/229185-050-3CC1C44E/Cardi-B-2019.jpg',
      ),
      Category(
        'James Arthur',
        'https://ymu-group.b-cdn.net/wp-content/uploads/2022/12/James-Arthur.jpg',
      )
    ];
  }
}
