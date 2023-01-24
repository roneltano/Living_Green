import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:living_plant/admin/home/adminHomePage.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:living_plant/widgets/updatingAPI.dart';

class adminDrawer extends StatelessWidget {
  Color color1 = const Color.fromARGB(128, 208, 199, 1);
  Color color2 = const Color.fromARGB(19, 84, 122, 1);
  String imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.adminImage) ?? "";
  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.adminFirstName);
  var lastName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.adminSecondName);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: const BoxDecoration(color: LivingPlant.primaryColor),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(18.0)),
                  elevation: 8.0,
                  child: SizedBox(
                    height: 160.0,
                    width: 160.0,
                    child: imageGetting.length > 5
                        ? CircleAvatar(
                            backgroundColor: Colors.black12,
                            backgroundImage: NetworkImage(imageGetting),
                            radius: 23,
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius: 23,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            decoration: const BoxDecoration(color: LivingPlant.primaryColor),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => adminHomePage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Chnage API",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => const apiPage());
                    Navigator.push(context, route);
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    var auth = FirebaseAuth.instance;
                    auth.signOut().then((c) {
                      Route route =
                          MaterialPageRoute(builder: (c) => const UserLogin());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                const Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
