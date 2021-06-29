import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/currentUser/currentUser.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:fosterhome/services/token_id_username_prefs/usernamePrefs.dart';
import 'package:http/http.dart' as http;

class CurrentUserServices {
  PrefService _prefService = PrefService();
  UserNamePref _userNamePref = UserNamePref();

  String text = "error";

  Future<ProfileModel> getCurrentUserProfile() async {
    String? token = await (_prefService.readCache(TOKEN_KEY));
    String? username = await _userNamePref.readUserName(USER_NAME_KEY);

    var response =
        await http.get(Uri.https(API_URL, "user/getuser/$username"), headers: {
      "Content-type": "application/json;charset=UTF-8",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      final ProfileModel profileModel = profileModelFromJson(response.body);
      return profileModel;
    } else {
      return ProfileModel();
    }
  }
}
