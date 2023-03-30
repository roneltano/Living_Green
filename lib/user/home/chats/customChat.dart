import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/providers/traderProvider.dart';
import 'package:provider/provider.dart';

var chatDocId;

class customChat extends StatefulWidget {
  customChat({Key? key}) : super(key: key);

  @override
  _customChat createState() => _customChat();
}

class _customChat extends State<customChat> {
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
    chats.doc(tradeProvider.getCommonID).collection('messages').add({
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
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 130,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  tradeProvider.getTradeTowPlantImage
                                      .toString(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(
                              tradeProvider.getTradeTowPlantName.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              tradeProvider.getTradeTowFirstName.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              tradeProvider.getTradeTowPlantLocation.toString(),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        width: 140,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chekcing /////////////////////////////////////////////////////////////////////////
                            tradeProvider.getTradeOnePlantName != null
                                ? GestureDetector(
                                    onTap: () {
                                      showingBottomToUp();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: 130,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          tradeProvider.getTradeOnePlantImage
                                              .toString(),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      // This is for Picking Plant to choose
                                    ),
                                  )
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: const Color(0XFFC4C4C4),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.question_mark_outlined,
                                          size: 30,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              const Color(0XFFFFFFFF),
                                            ),
                                            padding: MaterialStateProperty.all(
                                              const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 10,
                                                right: 10,
                                              ),
                                            ),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            showingBottomToUp();
                                          },
                                          child: const Text(
                                            "Browse",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Text(
                              tradeProvider.getTradeOnePlantName.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(
                              tradeProvider.getTradeOneFirstName.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              tradeProvider.getTradeOnePlantLocation.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text("Trade"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: chats
                          .doc(tradeProvider.getCommonID)
                          .collection('messages')
                          .orderBy('createdOn', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
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
                                      .docs[index]['ReceiverImageProfile'];
                                  String senderUserImageProfile = snapshot
                                      .data!.docs[index]['senderProfileImage'];
                                  return Column(
                                    children: [
                                      senderUserImageProfile.length > 5
                                          ? isSender(snapshot.data!.docs[index]
                                                  ['sender'])
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
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
                                                                    .docs[index]
                                                                        ['msg']
                                                                    .toString(),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black12,
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
                                                      const EdgeInsets.all(5.0),
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
                                                                Colors.black12,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    reciverUserImageProfile),
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
                                                                    .docs[index]
                                                                        ['msg']
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
            Container(
              padding:
                  const EdgeInsets.only(right: 10, bottom: 2, top: 2, left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6), color: Colors.white),
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
          ],
        ),
      ),
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

                              String plantAcceptingUID =
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
                                      onPressed: () async {
                                        //Trying Trade One
                                        tradeProvider.updateTradeOneUid(
                                            currentUserId.toString());

                                        tradeProvider
                                            .updateTradeOnePlantImage(plantUrl);

                                        tradeProvider.updateTradeOneFirstName(
                                            LivingPlant.sharedPreferences!
                                                .getString(
                                                    LivingPlant.firstName)
                                                .toString());

                                        tradeProvider.updateTradeOneLastName(
                                            LivingPlant.sharedPreferences!
                                                .getString(LivingPlant.lastName)
                                                .toString());

                                        tradeProvider
                                            .updateTradeOnePlantLocation(
                                                locationTowTrade);

                                        tradeProvider.updateTradeOnePlantName(
                                            plantNameTow);

                                        tradeProvider
                                            .updateTradeOnePlantImage(plantUrl);

                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //       builder: (_) => MyPlants()),
                                        // );

                                        // Make the plant as Pending
                                        // Once the plant is picked, it will be pending for trade.

                                        // Save to firebase the plant selected

                                        await LivingPlant.firebaseFirestore!
                                            .collection("chats")
                                            .doc(tradeProvider.getCommonID)
                                            .update({
                                          // Plants Informations
                                          "PlantPickedByWantingToGiveName":
                                              plantNameTow,
                                          "PlantPickedByWantingToGiveUrl":
                                              plantUrl,
                                          "PlantPickedByWantingToGiveLocation":
                                              locationTowTrade,
                                          "PlantPickedByWantingToGiveUID":
                                              plantAcceptingUID.toString(),
                                        }).then((value) async {
                                          // await LivingPlant.firebaseFirestore!
                                          //     .collection("plantsCollection")
                                          //     .doc(plantAcceptingUID)
                                          //     .update(
                                          //   {
                                          //     "PlantAvilability": "pending",
                                          //   },
                                          // );
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
