import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/providers/traderProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as dateFromat;

class tradeHisotryChat extends StatefulWidget {
  tradeHisotryChat({Key? key}) : super(key: key);

  @override
  _tradeHisotryChat createState() => _tradeHisotryChat();
}

class _tradeHisotryChat extends State<tradeHisotryChat> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  String imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image) ?? "";
  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);

  var expertOrNot =
      LivingPlant.sharedPreferences!.getString(LivingPlant.expertMark);

  String? getFirstWords(String? sentence, int wordCounts) {
    return sentence?.split(" ").sublist(0, wordCounts).join(" ");
  }

  void getImage(String imagePath) {
    if (imagePath == '') return;
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    var tradeProvider = Provider.of<traderProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Row(
              children: [
                imageGetting.length > 5
                    ? CircleAvatar(
                        backgroundColor: Colors.black12,
                        backgroundImage: NetworkImage(imageGetting),
                        radius: 16,
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: Container(
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
                    .where("ChatUID", isEqualTo: tradeProvider.getChatUid)
                    .limit(1)
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
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              right: 15, left: 15, top: 8, bottom: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(10),
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
                                                BorderRadius.circular(10),
                                          ),
                                          width: 130,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              snapshot
                                                  .data!
                                                  .docs[index]
                                                      ['PlantPickedByTraderUrl']
                                                  .toString(),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapshot
                                              .data!
                                              .docs[index]
                                                  ['PlantPickedByTraderName']
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          snapshot
                                              .data!
                                              .docs[index]
                                                  ['TraderAskedFullName']
                                              .toString(),
                                          style: const TextStyle(fontSize: 12),
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
                                        Text(
                                          snapshot.data!
                                              .docs[index]['TraderAskedStatus']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: snapshot.data!.docs[index][
                                                          'TraderAskedStatus'] ==
                                                      "Pending"
                                                  ? Colors.red
                                                  : Colors.green),
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(10),
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
                                                BorderRadius.circular(10),
                                          ),
                                          width: 130,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              snapshot
                                                  .data!
                                                  .docs[index][
                                                      'PlantPickedByWantingToGiveUrl']
                                                  .toString(),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapshot
                                              .data!
                                              .docs[index][
                                                  'PlantPickedByWantingToGiveName']
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          snapshot
                                              .data!
                                              .docs[index]
                                                  ['TraderAcceptingFullName']
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
                                        Text(
                                          snapshot
                                              .data!
                                              .docs[index]
                                                  ['TraderAcceptingStatust']
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: snapshot.data!.docs[index][
                                                          'TraderAcceptingStatust'] ==
                                                      "Pending"
                                                  ? Colors.red
                                                  : Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // : Text("")
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: chats
                            .doc(tradeProvider.getChatUid)
                            .collection('messages')
                            .orderBy('createdOn', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("Something went wrong"),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  reverse: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data!.docs[index];

                                    String reciverUserImageProfile = snapshot
                                        .data!
                                        .docs[index]['ReceiverImageProfile']
                                        .toString();

                                    String senderUserImageProfile = snapshot
                                        .data!.docs[index]['senderProfileImage']
                                        .toString();
                                    return Column(
                                      children: [
                                        senderUserImageProfile.length > 5
                                            ? isSender(snapshot.data!
                                                    .docs[index]['sender'])
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Flexible(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    20,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'msg']
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black12,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      senderUserImageProfile),
                                                              radius: 23,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .black12,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      senderUserImageProfile),
                                                              radius: 23,
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Flexible(
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    20,
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'msg']
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                            : const CircleAvatar(
                                                backgroundColor: Colors.black12,
                                                radius: 23,
                                              ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
