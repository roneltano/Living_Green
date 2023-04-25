import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/home/PlantRecognitions/bottomAndUp.dart';
import 'package:living_plant/user/home/notificationPage.dart';
import 'package:living_plant/user/home/searching.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/NotificationProvider.dart';
import 'package:provider/provider.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class TopNav extends StatefulWidget {
  const TopNav({super.key});

  @override
  State<TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<TopNav> {
  @override
  Widget build(BuildContext context) {
    var notifProvider =
        Provider.of<NotificationProvider>(context, listen: true);

    final currentUserId = LivingPlant.firebaseAuth!.currentUser?.uid;
    bool isSender(String friend) {
      return friend == currentUserId;
    }

    bool isBadgePressed = notifProvider.getRead ?? true;

    Future<AggregateQuerySnapshot> count = LivingPlant.firebaseFirestore!
        .collection('chats')
        .where('TradeStatus', isEqualTo: 'Pending')
        .where('TraderAcceptingUid', isEqualTo: currentUserId)
        .where('Read', isEqualTo: false)
        .count()
        .get();

    Future quiriedDocs = LivingPlant.firebaseFirestore!
        .collection('chats')
        .where('TradeStatus', isEqualTo: 'Pending')
        .where('TraderAcceptingUid', isEqualTo: currentUserId)
        .where('Read', isEqualTo: false)
        .get();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    Future<QuerySnapshot<Map<String, dynamic>>> userNotif = firestore
        .collection('chats')
        .where('TradeStatus', isEqualTo: 'Pending')
        .where('TraderAcceptingUid', isEqualTo: currentUserId)
        .where('Read', isEqualTo: false)
        .get();

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
                              "Discover new plants now!",
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
                                FutureBuilder<AggregateQuerySnapshot>(
                                  future: count,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      int docCount = snapshot.data!.count;
                                      int oldNotif =
                                          notifProvider.newNotif ?? 0;
                                      if (oldNotif < docCount) {
                                        notifProvider.updateRead(true);
                                        notifProvider.updateNewNotif(docCount);
                                      }
                                      return badges.Badge(
                                        showBadge: isBadgePressed,
                                        badgeContent: const Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                          size: 1,
                                        ),
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            notifProvider
                                                .updateNewNotif(docCount);
                                            notifProvider.updateRead(false);
                                            goingToNotifications(context);
                                          },
                                          icon: const Icon(
                                            Icons.notifications,
                                            size: 28,
                                          ),
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
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

  void resetBadge(bool isBadgePressed) async {
    print('shit');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('badgePressed', true);
    bool value = prefs.getBool('badgePressed') ?? false;
    setState(() {
      isBadgePressed = value;
    });
  }
}
