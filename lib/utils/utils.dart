import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openlink({
    @required String? url,
  }) =>
      _launcUrl(url!);

  static Future _launcUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
