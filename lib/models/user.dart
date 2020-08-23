import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  Uri url;
  String username;
  String bearer;

  void setUrl(String newurl) {
    url = Uri.parse(newurl);
    if (url.scheme == "") {
      url = Uri.parse("https://" + newurl);
    }
  }
}

