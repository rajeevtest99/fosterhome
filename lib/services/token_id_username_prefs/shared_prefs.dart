import 'package:fosterhome/consts/token_id_username.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  Future createCache(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(TOKEN_KEY, token);
  }

  Future readCache(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var cache = _prefs.getString(TOKEN_KEY);
    return cache;
  }

  Future removeCache(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(TOKEN_KEY);
  }
}
