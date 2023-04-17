import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class searchProvider with ChangeNotifier {
  // For Posting

  String? _userSearchProfile;

  String? get getProfile => _userSearchProfile;

  updateUserSearchProfile(String userSearchProfile) {
    _userSearchProfile = userSearchProfile;
    notifyListeners();
  }
}
