import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/traderProvider.dart';
import 'package:living_plant/user/home/chats/exisitingChat.dart';
import 'package:intl/intl.dart' as dateFromat;
import 'package:living_plant/user/home/chats/pendingTrades.dart';

import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  final currentUserId = LivingPlant.firebaseAuth!.currentUser?.uid;

  var imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image);
  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);
  var address = LivingPlant.sharedPreferences!.getString(LivingPlant.address);

  String? getFirstWords(String? sentence, int wordCounts) {
    return sentence?.split(" ").sublist(0, wordCounts).join(" ");
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    var tradeProvider = Provider.of<traderProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade400,
              ),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: LivingPlant.firebaseFirestore!
                        .collection("chats")
                        .where("TradeStatus", isEqualTo: "Pending")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text('No Notifications'),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return snapshot.data!.docs[index]
                                            ['TraderAskedUid'] ==
                                        currentUserId ||
                                    snapshot.data!.docs[index]
                                            ['TraderAcceptingUid'] ==
                                        currentUserId
                                ? Container(
                                    margin: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                        onTap: () {
                                          Route route = MaterialPageRoute(
                                              builder: (_) => PendingTrades());
                                          Navigator.push(context, route);
                                        },
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot
                                                        .data!.docs[index]
                                                    ['PlantPickedByTraderUrl'],
                                                width: 80.0,
                                                height: 80.0,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .docs[index][
                                                          'TraderAcceptingFullName']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const Text(
                                                  'Wants to trade with you',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot
                                                      .data!
                                                      .docs[index][
                                                          'PlantPickedByTraderName']
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
                                  )
                                : Container();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  // This is to show the plants the user owns
}
