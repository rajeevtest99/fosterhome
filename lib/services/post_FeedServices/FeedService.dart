import 'dart:convert';

import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/FeedAndDetailPostModel/postDetailModel.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/userIdPrefs.dart';
import 'package:http/http.dart' as http;

class FeedServices {
  UserIdPref _idPref = UserIdPref();
  PrefService _prefService = PrefService();
  String url = "fosterhomes.herokuapp.com";

  Future<DetailPost?> getFeed() async {
    String? id = await (_idPref.readId(USER_ID_KEY));
    String? token = await (_prefService.readCache(TOKEN_KEY));

    dynamic detailPostModel;

    var response =
        await http.get(Uri.https(API_URL, "/posts/timeline/all/$id"), headers: {
      "Content-type": "application/json;charset=UTF-8",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    print(response.body);
    try {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        detailPostModel = DetailPost.fromJson(jsonMap);
      }
    } catch (Exception) {
      return detailPostModel;
    }

    return detailPostModel;
  }
}
