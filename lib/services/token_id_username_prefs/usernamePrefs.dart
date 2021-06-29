import 'package:fosterhome/consts/token_id_username.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNamePref {
  Future saveUserName(String userName) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(USER_NAME_KEY, userName);
  }

  Future readUserName(String userName) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var cache = _prefs.getString(USER_NAME_KEY);
    return cache;
  }

  Future removeUserName(String userName) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(USER_NAME_KEY);
  }
}
