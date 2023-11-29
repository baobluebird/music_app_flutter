import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../ipconfig/ipconfig.dart';

class CreateMusicService {
  static Future<Map<String, dynamic>> createMusic(String idUser,String name, String genres, String singer, String description, File? image, File? music) async {
    final url = Uri.parse('http://$ip:3003/api/music/create');
    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('image', image!.path));
    request.files.add(await http.MultipartFile.fromPath('music', music!.path));
    request.fields['user'] = idUser;
    request.fields['name'] = name;
    request.fields['genres'] = genres;
    request.fields['singer'] = singer;
    request.fields['description'] = description;

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        return {'status':decodedResponse['status'], 'message': decodedResponse['message']};
      } else {
        print('Error: ${response.statusCode}');
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (error) {
      print('Error: $error');
      return {'status': 'error', 'message': 'Network error'};
    }
  }
}