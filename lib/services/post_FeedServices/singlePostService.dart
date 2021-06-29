import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/FeedAndDetailPostModel/SinglePostModel.dart';

import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';

import 'package:http/http.dart' as http;

class SinglePostServices {
  PrefService _prefService = PrefService();

  String text = "error";

  Future<SinglePost> singlePost(String? postid) async {
    String? token = await (_prefService.readCache(TOKEN_KEY));

    var response = await http.get(Uri.https(API_URL, "posts/$postid"),
        headers: {"Authorization": "Bearer $token"});
    print(response.body);

    if (response.statusCode == 200) {
      final SinglePost sinlePost = singlePostFromJson(response.body);
      print(sinlePost);
      return sinlePost;
    } else {
      return SinglePost();
    }
  }
}
