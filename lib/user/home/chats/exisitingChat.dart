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
import 'package:living_plant/user/home/chats/customChat.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as dateFromat;

class exisitingChat extends StatefulWidget {
  exisitingChat({Key? key}) : super(key: key);

  @override
  _exisitingChat createState() => _exisitingChat();
}

class _exisitingChat extends State<exisitingChat> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var userName;
  XFile? xfile;
  late File imageFile;
  String? imageUrl;
  final ImagePicker _picker = ImagePicker();
  var _textController = new TextEditingController();

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

  sendMessage(String msg) {
    var tradeProvider = Provider.of<traderProvider>(context, listen: false);

    if (msg == '') return;
    print("It's coming here");
    chats.doc(tradeProvider.getChatUid).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'sender': currentUserId,
      'ReceieverUid': tradeProvider.getTradeTowUid,
      'ReceiverImageProfile': tradeProvider.getTradeTowProfileUrl,
      'senderProfileImage':
          LivingPlant.sharedPreferences!.getString(LivingPlant.image),
      'SenderName':
          "${LivingPlant.sharedPreferences!.getString(LivingPlant.firstName)} ${LivingPlant.sharedPreferences!.getString(LivingPlant.lastName)}",
      'ReceiverName': "${tradeProvider.getTradeTowFirstName}",
      'msg': msg,
      'sentBy':
          "${LivingPlant.sharedPreferences!.getString(LivingPlant.firstName)} ${LivingPlant.sharedPreferences!.getString(LivingPlant.lastName)}",
    }).then((value) {
      _textController.text = '';
    });
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
  void dispose() {
    super.dispose();
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
                    // .where("TradeStatus", isEqualTo: "Pending")
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
                                        // Chekcing /////////////////////////////////////////////////////////////////////////
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
                                          // This is for Picking Plant to choose
                                        )
                                        // Container(
                                        //     width: MediaQuery.of(context)
                                        //         .size
                                        //         .width,
                                        //     padding:
                                        //         const EdgeInsets.all(10),
                                        //     height: 100,
                                        //     decoration: BoxDecoration(
                                        //         color:
                                        //             const Color(0XFFC4C4C4),
                                        //         borderRadius:
                                        //             BorderRadius.circular(
                                        //                 10)),
                                        //     child: Column(
                                        //       children: [
                                        //         const Icon(
                                        //           Icons
                                        //               .question_mark_outlined,
                                        //           size: 30,
                                        //         ),
                                        //         ElevatedButton(
                                        //           style: ButtonStyle(
                                        //             backgroundColor:
                                        //                 MaterialStateProperty
                                        //                     .all(
                                        //               const Color(
                                        //                   0XFFFFFFFF),
                                        //             ),
                                        //             padding:
                                        //                 MaterialStateProperty
                                        //                     .all(
                                        //               const EdgeInsets.only(
                                        //                 top: 5,
                                        //                 bottom: 5,
                                        //                 left: 10,
                                        //                 right: 10,
                                        //               ),
                                        //             ),
                                        //             shape:
                                        //                 MaterialStateProperty
                                        //                     .all(
                                        //               RoundedRectangleBorder(
                                        //                 borderRadius:
                                        //                     BorderRadius
                                        //                         .circular(
                                        //                   20.0,
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           onPressed: () {
                                        //             // showingBottomToUp();
                                        //           },
                                        //           child: const Text(
                                        //             "Browse",
                                        //             style: TextStyle(
                                        //                 color:
                                        //                     Colors.black),
                                        //           ),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        ,
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
                              ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const loadingDialog(
                                        message: "Trading Plant, Please wait"),
                                  );
                                  isSender(snapshot.data!.docs[index]
                                          ['TraderAskedUid'])
                                      ? await LivingPlant.firebaseFirestore!
                                          .collection("chats")
                                          .doc(tradeProvider.getChatUid)
                                          .update(
                                              {"TraderAskedStatus": "Accepted"})
                                      : await LivingPlant.firebaseFirestore!
                                          .collection("chats")
                                          .doc(tradeProvider.getChatUid)
                                          .update({
                                          "TraderAcceptingStatust": "Accepted"
                                        });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text("Trade"),
                              ),
                              snapshot.data!.docs[index]['TraderAskedStatus'] ==
                                          "Accepted" &&
                                      snapshot.data!.docs[index]
                                              ['TraderAcceptingStatust'] ==
                                          "Accepted"
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        if (snapshot.data!.docs[index]
                                                    ['TraderAskedStatus'] ==
                                                "Accepted" &&
                                            snapshot.data!.docs[index][
                                                    'TraderAcceptingStatust'] ==
                                                "Accepted") {
                                          ////////////////////////// First Trader //////////////////////////////////////
                                          await LivingPlant.firebaseFirestore!
                                              .collection("plantsCollection")
                                              .doc(snapshot.data!
                                                  .docs[index]['PlantAskedUid']
                                                  .toString())
                                              .update({
                                            "plantName": snapshot
                                                .data!
                                                .docs[index]
                                                    ['PlantPickedByTraderName']
                                                .toString(),
                                            "plantUrl": snapshot
                                                .data!
                                                .docs[index]
                                                    ['PlantPickedByTraderUrl']
                                                .toString(),
                                            "dateAdded": dateFromat.DateFormat(
                                                    'dd-MM-yyyy')
                                                .format(DateTime.now()),
                                            "plantDescription": "noDes",
                                            "userUID": snapshot.data!
                                                .docs[index]['TraderAskedUid']
                                                .toString(),
                                            "userFullName":
                                                snapshot.data!.docs[index]
                                                    ['TraderAskedFullName'],
                                            "location": snapshot
                                                    .data!.docs[index]
                                                ['PlantPickedByTraderLocation'],
                                          }).then((value) async {
                                            ////////////////////////// Second Trader //////////////////////////////////////
                                            await LivingPlant.firebaseFirestore!
                                                .collection("plantsCollection")
                                                .doc(snapshot
                                                    .data!
                                                    .docs[index][
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
                                              "dateAdded":
                                                  dateFromat.DateFormat(
                                                          'dd-MM-yyyy')
                                                      .format(DateTime.now()),
                                              "plantDescription": "noDes",
                                              "userUID": snapshot
                                                  .data!
                                                  .docs[index]
                                                      ['TraderAcceptingUid']
                                                  .toString(),
                                              "userFullName": snapshot
                                                      .data!.docs[index]
                                                  ['TraderAcceptingFullName'],
                                              "location": snapshot
                                                      .data!.docs[index][
                                                  'PlantPickedByWantingToGiveLocation'],
                                            });
                                            await LivingPlant.firebaseFirestore!
                                                .collection("chats")
                                                .doc(tradeProvider.getChatUid!)
                                                .update({
                                              "TradeStatus": "Accepted",
                                            });
                                          });
                                        }
                                        Navigator.pop(context);
                                        tradeProvider.updateChatUid('');
                                      },
                                      child: Text("Confirm Trade"),
                                    )
                                  : Text("")
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

              Container(
                padding: const EdgeInsets.only(
                    right: 10, bottom: 2, top: 2, left: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white),
                height: 55,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: _textController,
                        obscureText: false,
                        cursorColor: LivingPlant.primaryColor,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          isCollapsed: true,
                          isDense: true,
                          suffixIconColor: LivingPlant.primaryColor,
                          suffixStyle:
                              const TextStyle(color: LivingPlant.primaryColor),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: LivingPlant.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          hintText: "hint",
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                              color: LivingPlant.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),

                          contentPadding: const EdgeInsets.all(12), //
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: SvgPicture.asset(
                          "images/send.svg",
                          height: 25,
                        ),
                        onPressed: () {
                          sendMessage(
                            _textController.text,
                          );
                        },
                      ),

                      // child: GestureDetector(
                      //   onTap: () {
                      //     sendMessage(_textController.text);
                      //   },
                      //   child: SvgPicture.asset("images/send.svg"),
                      // ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Column(
              //       children: [
              //         StreamBuilder<QuerySnapshot>(
              //           stream: LivingPlant.firebaseFirestore!
              //               .collection("chats")
              //               .doc(tradeProvider.getCommonID)
              //               .collection('messages')
              //               .orderBy('createdOn', descending: true)
              //               .snapshots(),
              //           builder: (BuildContext context,
              //               AsyncSnapshot<QuerySnapshot> snapshot) {
              //             if (snapshot.hasError) {
              //               return const Center(
              //                 child: Text("Something went wrong"),
              //               );
              //             }
              //             if (snapshot.connectionState ==
              //                 ConnectionState.waiting) {
              //               return const Center(
              //                 child: CircularProgressIndicator(),
              //               );
              //             }
              //             if (snapshot.hasData) {
              //               return Column(
              //                 children: [
              //                   ListView.builder(
              //                     shrinkWrap: true,
              //                     physics: const NeverScrollableScrollPhysics(),
              //                     reverse: true,
              //                     itemCount: snapshot.data!.docs.length,
              //                     itemBuilder: (context, index) {
              //                       var data = snapshot.data!.docs[index];
              //                       String reciverUserImageProfile = snapshot
              //                           .data!
              //                           .docs[index]['ReceiverImageProfile'];
              //                       String senderUserImageProfile = snapshot
              //                           .data!.docs[index]['senderProfileImage'];
              //                       return Column(
              //                         children: [
              //                           senderUserImageProfile.length > 5
              //                               ? isSender(snapshot.data!.docs[index]
              //                                       ['sender'])
              //                                   ? Padding(
              //                                       padding:
              //                                           const EdgeInsets.all(5.0),
              //                                       child: Column(
              //                                         children: [
              //                                           Row(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .end,
              //                                             crossAxisAlignment:
              //                                                 CrossAxisAlignment
              //                                                     .center,
              //                                             children: [
              //                                               Flexible(
              //                                                 child: Container(
              //                                                   padding:
              //                                                       const EdgeInsets
              //                                                           .all(10),
              //                                                   decoration:
              //                                                       BoxDecoration(
              //                                                     color: Colors
              //                                                         .white,
              //                                                     borderRadius:
              //                                                         BorderRadius
              //                                                             .circular(
              //                                                       20,
              //                                                     ),
              //                                                   ),
              //                                                   child: Text(
              //                                                     snapshot
              //                                                         .data!
              //                                                         .docs[index]
              //                                                             ['msg']
              //                                                         .toString(),
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                               const SizedBox(
              //                                                 width: 10,
              //                                               ),
              //                                               CircleAvatar(
              //                                                 backgroundColor:
              //                                                     Colors.black12,
              //                                                 backgroundImage:
              //                                                     NetworkImage(
              //                                                         senderUserImageProfile),
              //                                                 radius: 23,
              //                                               ),
              //                                             ],
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     )
              //                                   : Padding(
              //                                       padding:
              //                                           const EdgeInsets.all(5.0),
              //                                       child: Column(
              //                                         children: [
              //                                           Row(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .start,
              //                                             crossAxisAlignment:
              //                                                 CrossAxisAlignment
              //                                                     .center,
              //                                             children: [
              //                                               CircleAvatar(
              //                                                 backgroundColor:
              //                                                     Colors.black12,
              //                                                 backgroundImage:
              //                                                     NetworkImage(
              //                                                         reciverUserImageProfile),
              //                                                 radius: 23,
              //                                               ),
              //                                               const SizedBox(
              //                                                 width: 10,
              //                                               ),
              //                                               Flexible(
              //                                                 child: Container(
              //                                                   padding:
              //                                                       const EdgeInsets
              //                                                           .all(10),
              //                                                   decoration:
              //                                                       BoxDecoration(
              //                                                     color: Colors
              //                                                         .white,
              //                                                     borderRadius:
              //                                                         BorderRadius
              //                                                             .circular(
              //                                                       20,
              //                                                     ),
              //                                                   ),
              //                                                   child: Text(
              //                                                     snapshot
              //                                                         .data!
              //                                                         .docs[index]
              //                                                             ['msg']
              //                                                         .toString(),
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             ],
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     )
              //                               : const CircleAvatar(
              //                                   backgroundColor: Colors.black12,
              //                                   radius: 23,
              //                                 ),
              //                         ],
              //                       );
              //                     },
              //                   ),
              //                 ],
              //               );
              //             } else {
              //               return Container();
              //             }
              //           },
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 18.0),
              //         child: CupertinoTextField(
              //           controller: _textController,
              //         ),
              //       ),
              //     ),
              //     CupertinoButton(
              //       child: const Icon(Icons.send_sharp),
              //       onPressed: () => sendMessage(_textController.text),
              //     ),
              //   ],
              // ),
              // Container(
              //   padding:
              //       const EdgeInsets.only(right: 10, bottom: 2, top: 2, left: 10),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(6), color: Colors.white),
              //   height: 55,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 6,
              //         child: TextField(
              //           controller: _textController,
              //           obscureText: false,
              //           cursorColor: LivingPlant.primaryColor,
              //           keyboardType: TextInputType.text,
              //           decoration: InputDecoration(
              //             filled: true,
              //             isCollapsed: true,
              //             isDense: true,
              //             suffixIconColor: LivingPlant.primaryColor,
              //             suffixStyle:
              //                 const TextStyle(color: LivingPlant.primaryColor),
              //             border: OutlineInputBorder(
              //               borderSide: const BorderSide(
              //                 width: 1,
              //                 color: LivingPlant.primaryColor,
              //               ),
              //               borderRadius: BorderRadius.circular(30),
              //             ),
              //             hintText: "hint",
              //             focusedBorder: OutlineInputBorder(
              //               borderSide: const BorderSide(
              //                 width: 1,
              //                 color: LivingPlant.primaryColor,
              //               ),
              //               borderRadius: BorderRadius.circular(30),
              //             ),

              //             contentPadding: const EdgeInsets.all(12), //
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 1,
              //         child: IconButton(
              //           icon: SvgPicture.asset(
              //             "images/send.svg",
              //             height: 25,
              //           ),
              //           onPressed: () {
              //             sendMessage(
              //               _textController.text,
              //             );
              //           },
              //         ),

              //         // child: GestureDetector(
              //         //   onTap: () {
              //         //     sendMessage(_textController.text);
              //         //   },
              //         //   child: SvgPicture.asset("images/send.svg"),
              //         // ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // body: Container(
      //   color: Colors.grey.shade200,
      //   child: Column(
      //     children: [
      //       // Container(
      //       //   padding:
      //       //       const EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 5),
      //       //   child: Column(
      //       //     children: [
      //       //       Row(
      //       //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       //         children: [
      //       //           Container(
      //       //             decoration: BoxDecoration(
      //       //               color: Colors.white,
      //       //               borderRadius: BorderRadius.circular(10),
      //       //             ),
      //       //             padding: const EdgeInsets.all(10),
      //       //             width: 140,
      //       //             child: Column(
      //       //               mainAxisAlignment: MainAxisAlignment.start,
      //       //               crossAxisAlignment: CrossAxisAlignment.start,
      //       //               children: [
      //       //                 Container(
      //       //                   decoration: BoxDecoration(
      //       //                     borderRadius: BorderRadius.circular(10),
      //       //                   ),
      //       //                   width: 130,
      //       //                   height: 100,
      //       //                   child: ClipRRect(
      //       //                     borderRadius: BorderRadius.circular(10.0),
      //       //                     child: Image.network(
      //       //                       tradeProvider.getTradeTowPlantImage
      //       //                           .toString(),
      //       //                       fit: BoxFit.fill,
      //       //                     ),
      //       //                   ),
      //       //                 ),
      //       //                 Text(
      //       //                   tradeProvider.getTradeTowPlantName.toString(),
      //       //                   style: const TextStyle(
      //       //                       fontWeight: FontWeight.bold, fontSize: 12),
      //       //                 ),
      //       //                 Text(
      //       //                   tradeProvider.getTradeTowFirstName.toString(),
      //       //                   style: const TextStyle(
      //       //                     fontSize: 12,
      //       //                   ),
      //       //                 ),
      //       //                 Text(
      //       //                   tradeProvider.getTradeTowPlantLocation.toString(),
      //       //                   style: const TextStyle(
      //       //                     fontSize: 10,
      //       //                   ),
      //       //                 ),
      //       //               ],
      //       //             ),
      //       //           ),
      //       //           // if (tradeProvider.getTradeStatus == "Pending")
      //       //           Expanded(
      //       //             // child: Text(
      //       //             //   "Waiting for ${tradeProvider.getTradeTowFirstName} Acceptance!!!",
      //       //             // ),
      //       //             child: SvgPicture.asset(
      //       //               "images/2arrows.svg",
      //       //             ),
      //       //           ),
      //       //           // else
      //       //           // Current User Trade
      //       //           // Consumer<traderProvider>(
      //       //           //   builder: (context, tradeProvider, child) =>
      //       //           Container(
      //       //             decoration: BoxDecoration(
      //       //               color: Colors.white,
      //       //               borderRadius: BorderRadius.circular(10),
      //       //             ),
      //       //             padding: const EdgeInsets.all(10),
      //       //             width: 140,
      //       //             child: Column(
      //       //               mainAxisAlignment: MainAxisAlignment.start,
      //       //               crossAxisAlignment: CrossAxisAlignment.start,
      //       //               children: [
      //       //                 // Chekcing /////////////////////////////////////////////////////////////////////////
      //       //                 tradeProvider.getTradeOnePlantName != null
      //       //                     ? GestureDetector(
      //       //                         onTap: () {
      //       //                           showingBottomToUp();
      //       //                         },
      //       //                         child: Container(
      //       //                           decoration: BoxDecoration(
      //       //                             borderRadius: BorderRadius.circular(10),
      //       //                           ),
      //       //                           width: 130,
      //       //                           height: 100,
      //       //                           child: ClipRRect(
      //       //                             borderRadius:
      //       //                                 BorderRadius.circular(10.0),
      //       //                             child: Image.network(
      //       //                               tradeProvider.getTradeOnePlantImage
      //       //                                   .toString(),
      //       //                               fit: BoxFit.fill,
      //       //                             ),
      //       //                           ),
      //       //                           // This is for Picking Plant to choose
      //       //                         ),
      //       //                       )
      //       //                     : Container(
      //       //                         width: MediaQuery.of(context).size.width,
      //       //                         padding: const EdgeInsets.all(10),
      //       //                         height: 100,
      //       //                         decoration: BoxDecoration(
      //       //                             color: const Color(0XFFC4C4C4),
      //       //                             borderRadius:
      //       //                                 BorderRadius.circular(10)),
      //       //                         child: Column(
      //       //                           children: [
      //       //                             const Icon(
      //       //                               Icons.question_mark_outlined,
      //       //                               size: 30,
      //       //                             ),
      //       //                             ElevatedButton(
      //       //                               style: ButtonStyle(
      //       //                                 backgroundColor:
      //       //                                     MaterialStateProperty.all(
      //       //                                   const Color(0XFFFFFFFF),
      //       //                                 ),
      //       //                                 padding: MaterialStateProperty.all(
      //       //                                   const EdgeInsets.only(
      //       //                                     top: 5,
      //       //                                     bottom: 5,
      //       //                                     left: 10,
      //       //                                     right: 10,
      //       //                                   ),
      //       //                                 ),
      //       //                                 shape: MaterialStateProperty.all(
      //       //                                   RoundedRectangleBorder(
      //       //                                     borderRadius:
      //       //                                         BorderRadius.circular(
      //       //                                       20.0,
      //       //                                     ),
      //       //                                   ),
      //       //                                 ),
      //       //                               ),
      //       //                               onPressed: () {
      //       //                                 showingBottomToUp();
      //       //                               },
      //       //                               child: const Text(
      //       //                                 "Browse",
      //       //                                 style:
      //       //                                     TextStyle(color: Colors.black),
      //       //                               ),
      //       //                             ),
      //       //                           ],
      //       //                         ),
      //       //                       ),
      //       //                 Text(
      //       //                   tradeProvider.getTradeOnePlantName.toString(),
      //       //                   style: const TextStyle(
      //       //                       fontWeight: FontWeight.bold, fontSize: 12),
      //       //                 ),
      //       //                 Text(
      //       //                   tradeProvider.getTradeOneFirstName.toString(),
      //       //                   style: const TextStyle(
      //       //                     fontSize: 12,
      //       //                   ),
      //       //                 ),
      //       //                 Text(
      //       //                   tradeProvider.getTradeOnePlantLocation.toString(),
      //       //                   style: const TextStyle(
      //       //                     fontSize: 10,
      //       //                   ),
      //       //                 ),
      //       //               ],
      //       //             ),
      //       //           ),
      //       //         ],
      //       //       ),
      //       //       ElevatedButton(
      //       //         onPressed: () {},
      //       //         style:
      //       //             ElevatedButton.styleFrom(shape: const StadiumBorder()),
      //       //         child: const Text("Trade"),
      //       //       ),
      //       //     ],
      //       //   ),
      //       // ),
      //       Expanded(
      //         child: SingleChildScrollView(
      //           child: Column(
      //             children: [
      //               StreamBuilder<QuerySnapshot>(
      //                 stream: chats
      //                     .doc(tradeProvider.getChatUid)
      //                     .collection('messages')
      //                     .orderBy('createdOn', descending: true)
      //                     .snapshots(),
      //                 builder: (BuildContext context,
      //                     AsyncSnapshot<QuerySnapshot> snapshot) {
      //                   if (snapshot.hasError) {
      //                     return const Center(
      //                       child: Text("Something went wrong"),
      //                     );
      //                   }
      //                   if (snapshot.connectionState ==
      //                       ConnectionState.waiting) {
      //                     return const Center(
      //                       child: CircularProgressIndicator(),
      //                     );
      //                   }
      //                   if (snapshot.hasData) {
      //                     return Column(
      //                       children: [
      //                         ListView.builder(
      //                           shrinkWrap: true,
      //                           physics: const NeverScrollableScrollPhysics(),
      //                           reverse: true,
      //                           itemCount: snapshot.data!.docs.length,
      //                           itemBuilder: (context, index) {
      //                             var data = snapshot.data!.docs[index];
      //                             String reciverUserImageProfile = snapshot
      //                                 .data!.docs[index]['ReceiverImageProfile']
      //                                 .toString();
      //                             String senderUserImageProfile = snapshot
      //                                 .data!.docs[index]['senderProfileImage']
      //                                 .toString();
      //                             return Column(
      //                               children: [
      //                                 senderUserImageProfile.length > 5
      //                                     ? isSender(snapshot.data!.docs[index]
      //                                             ['sender'])
      //                                         ? Padding(
      //                                             padding:
      //                                                 const EdgeInsets.all(5.0),
      //                                             child: Column(
      //                                               children: [
      //                                                 Row(
      //                                                   mainAxisAlignment:
      //                                                       MainAxisAlignment
      //                                                           .end,
      //                                                   crossAxisAlignment:
      //                                                       CrossAxisAlignment
      //                                                           .center,
      //                                                   children: [
      //                                                     Flexible(
      //                                                       child: Container(
      //                                                         padding:
      //                                                             const EdgeInsets
      //                                                                 .all(10),
      //                                                         decoration:
      //                                                             BoxDecoration(
      //                                                           color: Colors
      //                                                               .white,
      //                                                           borderRadius:
      //                                                               BorderRadius
      //                                                                   .circular(
      //                                                             20,
      //                                                           ),
      //                                                         ),
      //                                                         child: Text(
      //                                                           snapshot
      //                                                               .data!
      //                                                               .docs[index]
      //                                                                   ['msg']
      //                                                               .toString(),
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                     const SizedBox(
      //                                                       width: 10,
      //                                                     ),
      //                                                     CircleAvatar(
      //                                                       backgroundColor:
      //                                                           Colors.black12,
      //                                                       backgroundImage:
      //                                                           NetworkImage(
      //                                                               senderUserImageProfile),
      //                                                       radius: 23,
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                           )
      //                                         : Padding(
      //                                             padding:
      //                                                 const EdgeInsets.all(5.0),
      //                                             child: Column(
      //                                               children: [
      //                                                 Row(
      //                                                   mainAxisAlignment:
      //                                                       MainAxisAlignment
      //                                                           .start,
      //                                                   crossAxisAlignment:
      //                                                       CrossAxisAlignment
      //                                                           .center,
      //                                                   children: [
      //                                                     CircleAvatar(
      //                                                       backgroundColor:
      //                                                           Colors.black12,
      //                                                       backgroundImage:
      //                                                           NetworkImage(
      //                                                               senderUserImageProfile),
      //                                                       radius: 23,
      //                                                     ),
      //                                                     const SizedBox(
      //                                                       width: 10,
      //                                                     ),
      //                                                     Flexible(
      //                                                       child: Container(
      //                                                         padding:
      //                                                             const EdgeInsets
      //                                                                 .all(10),
      //                                                         decoration:
      //                                                             BoxDecoration(
      //                                                           color: Colors
      //                                                               .white,
      //                                                           borderRadius:
      //                                                               BorderRadius
      //                                                                   .circular(
      //                                                             20,
      //                                                           ),
      //                                                         ),
      //                                                         child: Text(
      //                                                           snapshot.data!
      //                                                                   .docs[
      //                                                               index]['msg'],
      //                                                         ),
      //                                                       ),
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                               ],
      //                                             ),
      //                                           )
      //                                     : const CircleAvatar(
      //                                         backgroundColor: Colors.black12,
      //                                         radius: 23,
      //                                       ),
      //                               ],
      //                             );
      //                           },
      //                         ),
      //                       ],
      //                     );
      //                   } else {
      //                     return Container();
      //                   }
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       // Row(
      //       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       //   children: [
      //       //     Expanded(
      //       //       child: Padding(
      //       //         padding: const EdgeInsets.only(left: 18.0),
      //       //         child: CupertinoTextField(
      //       //           controller: _textController,
      //       //         ),
      //       //       ),
      //       //     ),
      //       //     CupertinoButton(
      //       //       child: const Icon(Icons.send_sharp),
      //       //       onPressed: () => sendMessage(_textController.text),
      //       //     ),
      //       //   ],
      //       // ),
      //       Container(
      //         padding:
      //             const EdgeInsets.only(right: 10, bottom: 2, top: 2, left: 10),
      //         decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(6), color: Colors.white),
      //         height: 55,
      //         child: Row(
      //           children: [
      //             Expanded(
      //               flex: 6,
      //               child: TextField(
      //                 controller: _textController,
      //                 obscureText: false,
      //                 cursorColor: LivingPlant.primaryColor,
      //                 keyboardType: TextInputType.text,
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   isCollapsed: true,
      //                   isDense: true,
      //                   suffixIconColor: LivingPlant.primaryColor,
      //                   suffixStyle:
      //                       const TextStyle(color: LivingPlant.primaryColor),
      //                   border: OutlineInputBorder(
      //                     borderSide: const BorderSide(
      //                       width: 1,
      //                       color: LivingPlant.primaryColor,
      //                     ),
      //                     borderRadius: BorderRadius.circular(30),
      //                   ),
      //                   hintText: "hint",
      //                   focusedBorder: OutlineInputBorder(
      //                     borderSide: const BorderSide(
      //                       width: 1,
      //                       color: LivingPlant.primaryColor,
      //                     ),
      //                     borderRadius: BorderRadius.circular(30),
      //                   ),

      //                   contentPadding: const EdgeInsets.all(12), //
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //               flex: 1,
      //               child: IconButton(
      //                 icon: SvgPicture.asset(
      //                   "images/send.svg",
      //                   height: 25,
      //                 ),
      //                 onPressed: () {
      //                   sendMessage(
      //                     _textController.text,
      //                   );
      //                 },
      //               ),

      //               // child: GestureDetector(
      //               //   onTap: () {
      //               //     sendMessage(_textController.text);
      //               //   },
      //               //   child: SvgPicture.asset("images/send.svg"),
      //               // ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // Future savingImageToDatabase() async {
  //   var tradeProvider = Provider.of<traderProvider>(context, listen: true);

  //   LivingPlant.firebaseFirestore!
  //       .collection("chats")
  //       .doc(chatDocId)
  //       .collection("messages")
  //       .add(
  //     {
  //       'createdOn': FieldValue.serverTimestamp(),
  //       'uid': currentUserId,
  //       'tradeNumberTow': tradeProvider.getTradeTowFirstName,
  //       'msg': _textController.text.trim(),
  //       'sentBy':
  //           LivingPlant.sharedPreferences!.getString(LivingPlant.firstName),
  //     },
  //   );
  // }

  // This is to show the plants the user owns
  showingBottomToUp() {
    var postProvider = Provider.of<postPageProvider>(context, listen: false);
    var tradeProvider = Provider.of<traderProvider>(context, listen: false);
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

                              String plantUID = snapshot.data!.docs[index].id;

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
                                    Text(
                                      "${getFirstWords(snapshot.data!.docs[index]['plantDescription'].toString(), 7).toString()}...",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // //Trying Trade One
                                        // LivingPlant.firebaseFirestore!
                                        //     .collection("chats")
                                        //     .doc(tradeProvider.getChatUid)
                                        //     .update({
                                        //   "PlantPickedByWantingToGiveName":
                                        //       plantNameTow.trim(),
                                        //   "PlantPickedByWantingToGiveUrl":
                                        //       plantUrl.trim(),
                                        //   "PlantPickedByWantingToGiveLocation":
                                        //       locationTowTrade.trim(),
                                        //   "PlantPickedByWantingToGiveUID":
                                        //       plantUID,
                                        // });
                                        // // Navigator.of(context).push(
                                        // //   MaterialPageRoute(
                                        // //       builder: (_) => MyPlants()),
                                        // // );
                                        print(tradeProvider.getChatUid);
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
