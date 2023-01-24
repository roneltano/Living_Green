import 'dart:async';
import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:living_plant/user/home/bottomAndUp.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  displaySplash() {
    Timer(const Duration(seconds: 5), () async {
      if (LivingPlant.firebaseAuth!.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const bottomAndUp()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const UserLogin()),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: LivingPlant.whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: Image.asset("images/logo.png"),
            ),
            const SizedBox(
              height: 40,
            ),
            const DefaultTextStyle(
              style: TextStyle(color: LivingPlant.primaryColor, fontSize: 30),
              child: Text('Welcome to Living Green'),
            ),
          ],
        ),
      ),
    );
  }
}
