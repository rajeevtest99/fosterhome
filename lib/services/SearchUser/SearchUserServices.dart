import 'dart:convert';

import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/models/searchModel/searchmodel.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class SearchUserServices {
  var log = Logger();
  Future<SearchUser?> searchuser(
    String? username,
  ) async {
    //dynamic searchUser = null;
    dynamic searchUser;
    final queryparams = {"username": "$username"};
    var response = await http.get(
      Uri.https(API_URL, "/user/searchuser", queryparams),
      headers: {
        "Content-type": "application/json;charset=UTF-8",
        "Accept": "application/json",
      },
    );

    log.i(response.body);
    log.i(response.statusCode);
    try {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        searchUser = SearchUser.fromJson(jsonMap);
      }
    } catch (Exception) {
      return searchUser;
    }
    return searchUser;
  }
}
