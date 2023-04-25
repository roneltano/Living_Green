import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool? _read;
  int? _newNotif;
  int? _oldNotif;

  bool? get getRead => _read;
  int? get newNotif => _newNotif;
  int? get oldNotif => _oldNotif;

  updateRead(bool Read) {
    _read = Read;
    notifyListeners();
  }

  updateNewNotif(int? newNotif) {
    _newNotif = newNotif;
    notifyListeners();
  }

  updateOldNotif(int? oldNotif) {
    _oldNotif = oldNotif;
    notifyListeners();
  }
}
