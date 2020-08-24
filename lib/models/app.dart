import 'package:flutter/foundation.dart';

class AppModel extends ChangeNotifier {
  Uri url;
  String username;
  String bearer;
  bool loggedIn = false;

  void setUrl(String newurl) {
    url = Uri.parse(newurl);
    if (url.scheme == "") {
      url = Uri.parse("https://" + newurl);
    }
  }

  void logout() {
    username = null;
    bearer = null;
    loggedIn = false;
  }
}
