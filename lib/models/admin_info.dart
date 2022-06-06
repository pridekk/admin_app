import 'package:flutter/foundation.dart';

class AdminInfo extends ChangeNotifier {
  AdminInfo();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value){
    _isLoggedIn = value;
    notifyListeners();
  }
}