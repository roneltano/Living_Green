import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:living_plant/user/home/aboutUs.dart';
import 'package:living_plant/user/home/chats/trades.dart';
import 'package:living_plant/user/home/myPlants.dart';
import 'package:living_plant/user/home/myPosts.dart';
import 'package:living_plant/user/home/updateAccountInformation.dart';
import 'package:provider/provider.dart';

class NewUserProfile extends StatelessWidget {
  const NewUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    var imageGetting =
        LivingPlant.sharedPreferences!.getString(LivingPlant.image);
    var firstName =
        LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
    var lastName =
        LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);
    var address = LivingPlant.sharedPreferences!.getString(LivingPlant.address);
    var postProvier = Provider.of<postPageProvider>(context, listen: false);
    User? user = LivingPlant.firebaseAuth!.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                imageGetting!.length > 5
                    ? CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(imageGetting),
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.black12,
                        radius: 70,
                      ),
                Text(
                  "$firstName $lastName",
                  style: const TextStyle(fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesome.direction,
                      size: 12,
                    ),
                    Text(
                      address.toString(),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (_) => const UpdateInformation());
                    Navigator.push(context, route);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        right: 30, left: 30, top: 30, bottom: 10),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF0EEEE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.person,
                          color: LivingPlant.primaryColor,
                        ),
                        Text(
                          "Account Information",
                          style: TextStyle(
                              color: LivingPlant.primaryColor, fontSize: 16),
                        ),
                        Icon(
                          FontAwesome.right_open,
                          size: 15,
                          color: LivingPlant.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    postProvier.updateUserProfile(user!.uid);
                    Route route =
                        MaterialPageRoute(builder: (_) => const MyPlants());
                    Navigator.push(context, route);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 10),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF0EEEE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          FontAwesome5.heart,
                          color: LivingPlant.primaryColor,
                          size: 17,
                        ),
                        Text(
                          "My Plants",
                          style: TextStyle(
                              color: LivingPlant.primaryColor, fontSize: 16),
                        ),
                        Icon(
                          FontAwesome.right_open,
                          size: 15,
                          color: LivingPlant.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    postProvier.updateUserProfile(user!.uid);
                    Route route =
                        MaterialPageRoute(builder: (_) => const MyPosts());
                    Navigator.push(context, route);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 10),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF0EEEE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          FontAwesome5.check_circle,
                          color: LivingPlant.primaryColor,
                          size: 17,
                        ),
                        Text(
                          "My Posts",
                          style: TextStyle(
                              color: LivingPlant.primaryColor, fontSize: 16),
                        ),
                        Icon(
                          FontAwesome.right_open,
                          size: 15,
                          color: LivingPlant.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const tradesMaking()));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 10),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF0EEEE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.history,
                          color: LivingPlant.primaryColor,
                        ),
                        Text(
                          "My Trade History",
                          style: TextStyle(
                              color: LivingPlant.primaryColor, fontSize: 16),
                        ),
                        Icon(
                          FontAwesome.right_open,
                          size: 15,
                          color: LivingPlant.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AboutUs()));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 10),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF0EEEE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.info,
                          color: LivingPlant.primaryColor,
                        ),
                        Text(
                          "About us",
                          style: TextStyle(
                              color: LivingPlant.primaryColor, fontSize: 16),
                        ),
                        Icon(
                          FontAwesome.right_open,
                          size: 15,
                          color: LivingPlant.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await LivingPlant.firebaseAuth!.signOut().then((value) {
                      Route route =
                          MaterialPageRoute(builder: (_) => UserLogin());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(right: 30, left: 30, bottom: 10),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0XFFF0EEEE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.logout,
                          color: LivingPlant.primaryColor,
                        ),
                        Text(
                          "Sign out",
                          style: TextStyle(
                              color: LivingPlant.primaryColor, fontSize: 16),
                        ),
                        Icon(
                          FontAwesome.right_open,
                          size: 15,
                          color: LivingPlant.primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
