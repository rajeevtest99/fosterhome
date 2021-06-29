import 'package:fosterhome/consts/token_id_username.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserIdPref {
  Future saveId(String userId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(USER_ID_KEY, userId);
  }

  Future readId(String userId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var cache = _prefs.getString(USER_ID_KEY);
    return cache;
  }

  Future removeId(String userId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(USER_ID_KEY);
  }
}
