import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/providers/traderProvider.dart';
import 'package:living_plant/user/home/chats/exisitingChat.dart';
import 'package:living_plant/user/home/chats/customChat.dart';
import 'package:intl/intl.dart' as dateFromat;

import 'package:provider/provider.dart';

class PendingTrades extends StatefulWidget {
  PendingTrades({Key? key}) : super(key: key);

  @override
  _PendingTrades createState() => _PendingTrades();
}

class _PendingTrades extends State<PendingTrades> {
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
        title: const Text("Pending Trades"),
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
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              String TraderAskedUid =
                                  snapshot.data!.docs[index]['TraderAskedUid'];
                              String gettingUIdPlant =
                                  snapshot.data!.docs[index].id;
                              return snapshot.data!.docs[index]
                                              ['TraderAskedUid'] ==
                                          currentUserId ||
                                      snapshot.data!.docs[index]
                                              ['TraderAcceptingUid'] ==
                                          currentUserId
                                  ? Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade200,
                                      ),
                                      padding: const EdgeInsets.only(
                                          right: 15,
                                          left: 15,
                                          top: 8,
                                          bottom: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: 140,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      width: 130,
                                                      height: 100,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: snapshot
                                                              .data!
                                                              .docs[index][
                                                                  'PlantPickedByTraderUrl']
                                                              .toString(),
                                                        ),
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index][
                                                              'TraderAskedFullName']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index][
                                                              'PlantPickedByTraderLocation']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: SvgPicture.asset(
                                                  "images/2arrows.svg",
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                width: 140,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Chekcing /////////////////////////////////////////////////////////////////////////
                                                    snapshot.data!.docs[index][
                                                                'PlantPickedByWantingToGiveUID'] !=
                                                            ''
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              if (TraderAskedUid ==
                                                                  currentUserId) {
                                                                showingBottomToUp(
                                                                    gettingUIdPlant);
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              width: 130,
                                                              height: 100,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child: CachedNetworkImage(
                                                                    imageUrl: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'PlantPickedByWantingToGiveUrl']
                                                                        .toString()),
                                                              ),
                                                              // This is for Picking Plant to choose
                                                            ),
                                                          )
                                                        : Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            height: 100,
                                                            decoration: BoxDecoration(
                                                                color: const Color(
                                                                    0XFFC4C4C4),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Column(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .question_mark_outlined,
                                                                  size: 30,
                                                                ),
                                                                TraderAskedUid ==
                                                                        currentUserId
                                                                    ? ElevatedButton(
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(
                                                                            const Color(0XFFFFFFFF),
                                                                          ),
                                                                          padding:
                                                                              MaterialStateProperty.all(
                                                                            const EdgeInsets.only(
                                                                              top: 5,
                                                                              bottom: 5,
                                                                              left: 10,
                                                                              right: 10,
                                                                            ),
                                                                          ),
                                                                          shape:
                                                                              MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                20.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          showingBottomToUp(
                                                                              gettingUIdPlant);
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Browse",
                                                                          style:
                                                                              TextStyle(color: Colors.black),
                                                                        ),
                                                                      )
                                                                    : Container()
                                                              ],
                                                            ),
                                                          ),
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index][
                                                              'PlantPickedByWantingToGiveName']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
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
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .docs[index][
                                                              'PlantPickedByWantingToGiveLocation']
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          snapshot.data!.docs[index][
                                                      'PlantPickedByWantingToGiveUID'] !=
                                                  ''
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        print(snapshot.data!
                                                            .docs[index].id);
                                                        tradeProvider
                                                            .updateChatUid(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id);
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (_) =>
                                                                exisitingChat(),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  const StadiumBorder()),
                                                      child: const Text("Chat"),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              const loadingDialog(
                                                                  message:
                                                                      "Trading Plant, Please wait"),
                                                        );
                                                        isSender(snapshot.data!
                                                                    .docs[index]
                                                                [
                                                                'TraderAskedUid'])
                                                            ? await LivingPlant
                                                                .firebaseFirestore!
                                                                .collection(
                                                                    "chats")
                                                                .doc(tradeProvider
                                                                    .getChatUid)
                                                                .update({
                                                                "TraderAskedStatus":
                                                                    "Accepted"
                                                              })
                                                            : await LivingPlant
                                                                .firebaseFirestore!
                                                                .collection(
                                                                    "chats")
                                                                .doc(tradeProvider
                                                                    .getChatUid)
                                                                .update({
                                                                "TraderAcceptingStatust":
                                                                    "Accepted"
                                                              });
                                                        if (snapshot.data!.docs[
                                                                        index][
                                                                    'TraderAskedStatus'] ==
                                                                "Accepted" &&
                                                            snapshot.data!.docs[
                                                                        index][
                                                                    'TraderAcceptingStatust'] ==
                                                                "Accepted") {
                                                          ////////////////////////// First Trader //////////////////////////////////////
                                                          await LivingPlant
                                                              .firebaseFirestore!
                                                              .collection(
                                                                  "plantsCollection")
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'PlantAskedUid']
                                                                  .toString())
                                                              .update({
                                                            "plantName": snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'PlantPickedByTraderName']
                                                                .toString(),
                                                            "plantUrl": snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'PlantPickedByTraderUrl']
                                                                .toString(),
                                                            "dateAdded": dateFromat
                                                                    .DateFormat(
                                                                        'dd-MM-yyyy')
                                                                .format(DateTime
                                                                    .now()),
                                                            "plantDescription":
                                                                "noDes",
                                                            "userUID": snapshot
                                                                .data!
                                                                .docs[index][
                                                                    'TraderAskedUid']
                                                                .toString(),
                                                            "userFullName": snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'TraderAskedFullName'],
                                                            "location": snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'PlantPickedByTraderLocation'],
                                                          }).then((value) async {
                                                            ////////////////////////// Second Trader //////////////////////////////////////
                                                            await LivingPlant
                                                                .firebaseFirestore!
                                                                .collection(
                                                                    "plantsCollection")
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'PlantPickedByWantingToGiveUID']
                                                                    .toString())
                                                                .update({
                                                              "plantName": snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'PlantPickedByWantingToGiveName']
                                                                  .toString(),
                                                              "plantUrl": snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'PlantPickedByWantingToGiveUrl']
                                                                  .toString(),
                                                              "dateAdded": dateFromat
                                                                      .DateFormat(
                                                                          'dd-MM-yyyy')
                                                                  .format(DateTime
                                                                      .now()),
                                                              "plantDescription":
                                                                  "noDes",
                                                              "userUID": snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'TraderAcceptingUid']
                                                                  .toString(),
                                                              "userFullName": snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'TraderAcceptingFullName'],
                                                              "location": snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'PlantPickedByWantingToGiveLocation'],
                                                            });
                                                            await LivingPlant
                                                                .firebaseFirestore!
                                                                .collection(
                                                                    "chats")
                                                                .doc(tradeProvider
                                                                    .getChatUid!)
                                                                .update({
                                                              "TradeStatus":
                                                                  "Accepted",
                                                            });
                                                          });
                                                        }
                                                        Navigator.pop(context);
                                                        tradeProvider
                                                            .updateChatUid('');
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape:
                                                                  const StadiumBorder()),
                                                      child:
                                                          const Text("Trade!"),
                                                    ),
                                                  ],
                                                )
                                              : Container()
                                        ],
                                      ),
                                    )
                                  : Container();
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This is to show the plants the user owns
  showingBottomToUp(gettingUIdPlant) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: LivingPlant.firebaseFirestore!
                      .collection("plantsCollection")
                      .where("userUID", isEqualTo: currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return Row(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            reverse: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              String userTradeTwoFullName =
                                  snapshot.data!.docs[index]['userFullName'];

                              String plantNameTow =
                                  snapshot.data!.docs[index]['plantName'];

                              String locationTowTrade =
                                  snapshot.data!.docs[index]['location'];

                              String plantUrl =
                                  snapshot.data!.docs[index]['plantUrl'];

                              String plantPickedUID =
                                  snapshot.data!.docs[index].id;

                              String plantDescripiton = snapshot
                                  .data!.docs[index]['plantDescription'];

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade200,
                                ),
                                padding:
                                    const EdgeInsets.only(right: 5, left: 5),
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.only(
                                          right: 10, top: 10, left: 10),
                                      height: 200,
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          snapshot.data!.docs[index]
                                              ['plantUrl'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['plantName'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    plantDescripiton.length > 6
                                        ? Text(
                                            "${getFirstWords(plantDescripiton.toString(), 7).toString()}...",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        : Text(
                                            plantDescripiton,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 10,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                    ElevatedButton(
                                      onPressed: () {
                                        print(gettingUIdPlant);
                                        LivingPlant.firebaseFirestore!
                                            .collection("chats")
                                            .doc(gettingUIdPlant)
                                            .update({
                                          "PlantPickedByWantingToGiveName":
                                              plantNameTow.trim(),
                                          "PlantPickedByWantingToGiveUrl":
                                              plantUrl.trim(),
                                          "PlantPickedByWantingToGiveLocation":
                                              locationTowTrade.trim(),
                                          "PlantPickedByWantingToGiveUID":
                                              plantPickedUID,
                                        });
                                      },
                                      child: const Text(
                                        "Pick Plant",
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 256,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
