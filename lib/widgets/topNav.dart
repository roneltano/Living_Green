import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/home/PlantRecognitions/bottomAndUp.dart';
import 'package:living_plant/user/home/notificationPage.dart';
import 'package:living_plant/user/home/searching.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class TopNav extends StatelessWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = LivingPlant.firebaseAuth!.currentUser?.uid;
    bool isSender(String friend) {
      return friend == currentUserId;
    }

    String imageGetting =
        LivingPlant.sharedPreferences!.getString(LivingPlant.image) ?? "";
    var firstName =
        LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
    var lastName =
        LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);

    var expertOrNot =
        LivingPlant.sharedPreferences!.getString(LivingPlant.expertMark);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color(0XFF2C965B),
      child: Column(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => searchingPage()),
                  );
                },
                child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(right: 60, left: 60, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.search,
                        color: LivingPlant.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Search",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  // child: TextField(
                  //   onChanged: (value) {
                  //     Navigator.of(context).push(
                  //         MaterialPageRoute(builder: (_) => searchingPage()));
                  //   },
                  //   decoration: InputDecoration(
                  //     isDense: true,
                  //     contentPadding: const EdgeInsets.all(0),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     focusColor: LivingPlant.primaryColor,
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //           color: LivingPlant.primaryColor, width: 2.0),
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //           color: LivingPlant.primaryColor, width: 2.0),
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //           color: LivingPlant.primaryColor, width: 2.0),
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     hintText: 'Search',
                  //     prefixIcon: const Icon(
                  //       Icons.search,
                  //       color: LivingPlant.primaryColor,
                  //     ),
                  //     hintStyle:
                  //         const TextStyle(color: Colors.grey, fontSize: 11),
                  //   ),
                  // ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        imageGetting.length > 5
                            ? CircleAvatar(
                                backgroundColor: Colors.black12,
                                backgroundImage: NetworkImage(imageGetting),
                                radius: 23,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 23,
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$firstName $lastName",
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                expertOrNot == "expert"
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : const Text(''),
                              ],
                            ),
                            const Text(
                              "Discrover new plants now!",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    goingToUploadImage(context);
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt_sharp,
                                    size: 28,
                                  ),
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    goingToNotifications(context);
                                  },
                                  icon: const Icon(
                                    Icons.notifications,
                                    size: 28,
                                  ),
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  goingToUploadImage(BuildContext context) {
    Route route = MaterialPageRoute(builder: (_) => const bottomAndUp());
    Navigator.push(context, route);
  }

  goingToNotifications(BuildContext context) {
    Route route = MaterialPageRoute(builder: (_) => NotificationPage());
    Navigator.push(context, route);
  }
}
