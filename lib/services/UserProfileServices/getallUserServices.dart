import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/consts/token_id_username.dart';
import 'package:fosterhome/models/UserProfileModel/AllUsersModel.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class GetAllUserServices {
  PrefService _prefService = PrefService();

  String text = "error";
  var log = Logger();

  Future<GetAllUsers> getAllUsers() async {
    String? token = await (_prefService.readCache(TOKEN_KEY));

    var response =
        await http.get(Uri.https(API_URL, "user/getallusers"), headers: {
      "Content-type": "application/json;charset=UTF-8",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      final GetAllUsers getallUsers = getAllUsersFromJson(response.body);
      log.i(response.body);
      return getallUsers;
    } else {
      return GetAllUsers();
    }
  }
}
