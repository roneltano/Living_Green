import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class traderProvider with ChangeNotifier {
  // Frist User
  static String? _tradeOneUid;
  static String? _tradeOneFirstName;
  static String? _tradeOneSecondName;
  static String? _tradeOnePlantName;
  static String? _tradeOnePlantImage;
  static String? _tradeOnePlantLocation;
  static String? _tradeOnePlantPicked;

  //Second User
  static String? _tradeTowUid;
  static String? _tradeTowFirstName;
  static String? _tradeTowSecondName;
  static String? _tradeTowPlantName;
  static String? _tradeTowPlantImage;
  static String? _tradeTowPlantLocation;
  static String? _tradeTowProfileUrl;
  static String? _tradeTowPlantPicked;

  //Common ID
  static String? _commonID;
  static String? _tradeStatus;
  static String? _chatUID;

  // Frist User Get
  String? get getTradeOneUid => _tradeOneUid;
  String? get getTradeOneFirstName => _tradeOneFirstName;
  String? get getTradeOneSecondName => _tradeOneSecondName;
  String? get getTradeOnePlantName => _tradeOnePlantName;
  String? get getTradeOnePlantImage => _tradeOnePlantImage;
  String? get getTradeOnePlantLocation => _tradeOnePlantLocation;
  String? get getTradeOnePlantPicked => _tradeOnePlantPicked;

  // Second User Get
  String? get getTradeTowUid => _tradeTowUid;
  String? get getTradeTowFirstName => _tradeTowFirstName;
  String? get getTradeTowSecondName => _tradeTowSecondName;
  String? get getTradeTowPlantName => _tradeTowPlantName;
  String? get getTradeTowPlantImage => _tradeTowPlantImage;
  String? get getTradeTowPlantLocation => _tradeTowPlantLocation;
  String? get getTradeTowProfileUrl => _tradeTowProfileUrl;
  String? get getTradeTowPlantPicked => _tradeTowPlantPicked;

  String? get getCommonID => _commonID;
  String? get getTradeStatus => _tradeStatus;
  String? get getChatUid => _chatUID;

  // This is the Plant Trade 1
  updateTradeOneUid(String TradeOneUid) {
    _tradeOneUid = TradeOneUid;
    notifyListeners();
  }

  updateTradeOneFirstName(String TradeOneFirstName) {
    _tradeOneFirstName = TradeOneFirstName;
    notifyListeners();
  }

  updateTradeOneLastName(String TradeOneLastName) {
    _tradeOneSecondName = TradeOneLastName;
    notifyListeners();
  }

  updateTradeOnePlantName(String TradeOnePlantName) {
    _tradeOnePlantName = TradeOnePlantName;
    notifyListeners();
  }

  updateTradeOnePlantImage(String TradeOnePlantImage) {
    _tradeOnePlantImage = TradeOnePlantImage;
    notifyListeners();
  }

  updateTradeOnePlantLocation(String TradeOnePlantLocation) {
    _tradeOnePlantLocation = TradeOnePlantLocation;
    notifyListeners();
  }

  updateTradeOnePlantPicked(String TradeOnePlantPicked) {
    _tradeOnePlantPicked = TradeOnePlantPicked;
    notifyListeners();
  }

  // This is the Plant Trade 2
  updateTradeTowUid(String TradeTowUid) {
    _tradeTowUid = TradeTowUid;
    notifyListeners();
  }

  updateTradeTowFirstName(String TradeTowFirstName) {
    _tradeTowFirstName = TradeTowFirstName;
    notifyListeners();
  }

  updateTradeTowLastName(String TradeTowLastName) {
    _tradeTowSecondName = TradeTowLastName;
    notifyListeners();
  }

  updateTradeTowPlantName(String TradeTowPlantName) {
    _tradeTowPlantName = TradeTowPlantName;
    notifyListeners();
  }

  updateTradeTOwPlantImage(String TradeTowPlantImage) {
    _tradeTowPlantImage = TradeTowPlantImage;
    notifyListeners();
  }

  updateTradeTowPlantLocation(String TradeTowPlantLocation) {
    _tradeTowPlantLocation = TradeTowPlantLocation;
    notifyListeners();
  }

  updateCommonID(String commonID) {
    _commonID = commonID;
    notifyListeners();
  }

  updateTradeStatus(String tradeStatus) {
    _tradeStatus = tradeStatus;
    notifyListeners();
  }

  updateTradeProfileUrl(String ImageProfile) {
    _tradeTowProfileUrl = ImageProfile;
    notifyListeners();
  }

  updateTradeTowPlantPicked(String TradeTowPlantPicked) {
    _tradeTowPlantPicked = TradeTowPlantPicked;
    notifyListeners();
  }

  updateChatUid(String chatUID) {
    _chatUID = chatUID;
    notifyListeners();
  }
}
