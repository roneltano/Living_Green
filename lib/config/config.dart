import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LivingPlant {
  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const address = 'address';
  static const mobileNum = 0;
  static const email = 'email';
  static const image = 'image';
  static const expertMark = 'expertMark';

  // static const expertFirstName = 'expertFirstName';
  // static const expertSecondName = 'expertSecondName';
  // static const expertAddress = 'expertAddress';
  // static const expertMobileNum = 0;
  // static const expertEmail = 'expertEmail';
  // static const expertImage = 'expertImage';

  static const adminFirstName = 'adminFirstName';
  static const adminSecondName = 'adminSecondName';
  static const adminAddress = 'adminAddress';
  static const adminMobileNum = 0;
  static const adminEmail = 'adminEmail';
  static const adminImage = 'adminImage';

  static const primaryColor = Color(0xFF2C965B);
  static const buttonColorBlue = Color(0xFF48A2F5);
  static const appBarColor = Color(0XFF2C965B);
  static const whiteColor = Color(0XFFFAFAFA);

  static FirebaseFirestore? firebaseFirestore;
  static FirebaseAuth? firebaseAuth;
  static FirebaseStorage? firebaseStorage;
  static SharedPreferences? sharedPreferences;
}
