import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._();
  static ApiService apiService = ApiService._();

  Future<String> uploadImage({required File image}) async {
    String link = "https://api.imgur.com/3/image";
    Uint8List userImage = await image.readAsBytes();
    String userImageString = base64Encode(userImage);
    http.Response res =
        await http.post(Uri.parse(link), body: userImageString, headers: {
      'Authorization': "Client-ID d2d6c87052ba504",
    });
    String userURL =
        'https://static.vecteezy.com/system/resources/thumbnails/035/997/315/small/ai-generated-cheerful-business-woman-standing-isolated-free-photo.jpg';
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      userURL = data['data']["link"];
    } else {
      if (kDebugMode) {
        print(res.statusCode);
      }
    }
    return userURL;
  }
}
