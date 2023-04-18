import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  // For Posting

  String? _userSearchProfile;

  String? get getProfile => _userSearchProfile;

  updateUserSearchProfile(String userSearchProfile) {
    _userSearchProfile = userSearchProfile;
    debugPrint(_userSearchProfile);
    notifyListeners();
  }
}
