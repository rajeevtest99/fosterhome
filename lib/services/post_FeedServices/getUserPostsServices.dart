import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/currentUser/CurrentUserPostModel.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';

import 'package:http/http.dart' as http;

class GetUserPostServices {
  PrefService _prefService = PrefService();

  String text = "error";

  Future<CurrentUserPostModel> getUserPost(String? id) async {
    String? token = await (_prefService.readCache(TOKEN_KEY));

    var response =
        await http.get(Uri.https(API_URL, "posts/getpost/$id"), headers: {
      "Content-type": "application/json;charset=UTF-8",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      final CurrentUserPostModel currentUserPostModel =
          currentUserPostModelFromJson(response.body);
      return currentUserPostModel;
    } else {
      return CurrentUserPostModel();
    }
  }
}
