import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class postPageProvider with ChangeNotifier {
  // For Posting
  static XFile? _xFile;
  String? _plantName;
  String? _API;
  String? _comment;
  String? _postMessage;
  String? _userProfile;

  //For Commenting
  String? _POSTUID;
  String? _commentID;
  int? _CommentCount;
  bool? _votedAlready;

  // For commenting
  String? get getPOSTUID => _POSTUID;
  String? get getcommentID => _commentID;
  int? get getCommentCount => _CommentCount;
  bool? get getvotedAlready => _votedAlready;
  String? get getUserProfile => _userProfile;

  // For Posting
  XFile? get xFileGetting => _xFile;
  String? get plantName => _plantName;
  String? get getAPI => _API;
  String? get gettingComment => _comment;
  String? get postMessage => _postMessage;

  updateingImage(XFile? xFileReturnFromFunction) {
    _xFile = xFileReturnFromFunction;
    notifyListeners();
  }

  updatePlantName(String? plantName) {
    _plantName = plantName;
    notifyListeners();
  }

  updateAPI(String api) {
    _API = api;
    notifyListeners();
  }

  updateComment(String comment) {
    _comment = comment;
    notifyListeners();
  }

  updatePostMessage(String postMessage) {
    _postMessage = postMessage;
    notifyListeners();
  }

  // For Commenting

  updatePOSTUID(String? POSTUID) {
    _POSTUID = POSTUID;
    notifyListeners();
  }

  updateCommentID(String commentID) {
    _commentID = commentID;
    notifyListeners();
  }

  updateCommentCount(int commentCount) {
    _CommentCount = commentCount;
    notifyListeners();
  }

  updateVotedAlready(bool VotedAlready) {
    _votedAlready = VotedAlready;
    notifyListeners();
  }

  // for user profile
  updateUserProfile(String userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }
}
