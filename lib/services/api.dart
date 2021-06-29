import 'dart:convert';

import 'package:fosterhome/consts/api_key.dart';
import 'package:fosterhome/services/token_id_username_prefs/shared_prefs.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Api {
  var log = Logger();
  PrefService _prefService = PrefService();
  Future<dynamic> get(String url) async {
    String? token = await (_prefService.readCache("myfostertoken"));
    var response = await http.get(
      Uri.https(API_URL, url),
      headers: {"Authorization": "Bearer $token"},
    );

    log.i(response.body);
    log.i(response.statusCode);
    return json.decode(response.body);
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    String? token = await (_prefService.readCache("myfostertoken"));
    var response = await http.post(
        Uri.https(
          API_URL,
          url,
        ),
        headers: {
          "Content-type": "application/json;charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));
    return response;
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    String? token = await (_prefService.readCache("myfostertoken"));
    var response = await http.put(Uri.https(API_URL, url),
        headers: {
          "Content-type": "application/json;charset=UTF-8",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode(body));
    return response;
  }

  Future<http.StreamedResponse> patch(String url, String filepath) async {
    String? token =
        await (_prefService.readCache("myfostertoken") as Future<String?>);
    var request = http.MultipartRequest('PATCH', Uri.https(API_URL, url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });

    var response = request.send();
    return response;
  }

  Future<dynamic> search() async {
    final queryparams = {"username": "rj"};
    var response = await http.get(
      Uri.https(API_URL, "/user/searchuser", queryparams),
      headers: {
        "Content-type": "application/json;charset=UTF-8",
        "Accept": "application/json",
      },
    );

    log.i(response.body);
    log.i(response.statusCode);
    return json.decode(response.body);
  }
}
