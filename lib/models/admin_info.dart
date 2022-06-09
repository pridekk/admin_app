import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AdminInfo extends ChangeNotifier {
  final _authentication = FirebaseAuth.instance;

  AdminInfo();

  bool _isLoggedIn = false;

  String _token = "";

  bool get isLoggedIn => _isLoggedIn;

  String get token => _token;

  set isLoggedIn(bool value){
    _isLoggedIn = value;
    User? user = _authentication.currentUser;

    if(user != null){
      user.getIdToken().then((value){
        debugPrint("change token $_token to ${value.substring(0,10)}");
        _token = value;
      });
    }
    notifyListeners();

  }

  set token(String value){
    debugPrint("change token $_token to ${value.substring(0,10)}");
    _token = value;
    notifyListeners();
  }

}