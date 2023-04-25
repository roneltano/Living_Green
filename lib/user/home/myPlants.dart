import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/providers/traderProvider.dart';
import 'package:living_plant/user/home/chats/customChat.dart';
import 'package:provider/provider.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({super.key});

  @override
  State<MyPlants> createState() => _MyPlants();
}

class _MyPlants extends State<MyPlants> {
  String imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image) ?? '';

  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);
  var address = LivingPlant.sharedPreferences!.getString(LivingPlant.address);

  String? currentUser = LivingPlant.firebaseAuth!.currentUser!.uid;

  String? getFirstWords(String? sentence, int wordCounts) {
    return sentence?.split(" ").sublist(0, wordCounts).join(" ");
  }

  //For the chat
  var chatDocId;
  String? imageProfileUrl;
  var userData = {};

  @override
  Widget build(BuildContext context) {
    var postProvider = Provider.of<postPageProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 250,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "images/Rectangle2.png",
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            size: 22,
                          ),
                          color: Colors.white,
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // showDialogFunctoin();
                          },
                          icon: const Icon(
                            Icons.more_vert_outlined,
                          ),
                          color: Colors.white,
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: LivingPlant.firebaseFirestore!
                          .collection("users")
                          .where("UserUid",
                              isEqualTo: postProvider.getUserProfile)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          imageProfileUrl = snapshot.data!.docs[0]['imageUrl'];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              imageGetting.length > 5
                                  ? CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.docs[0]['imageUrl']),
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${snapshot.data!.docs[0]['firstName']} ${snapshot.data!.docs[0]['lastName']}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 23),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                  Text(
                                    '${snapshot.data!.docs[0]['firstName']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0XFF48A2F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "MY PLANTS",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Plant",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF36455A),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: LivingPlant.firebaseFirestore!
                                .collection("plantsCollection")
                                .where("userUID",
                                    isEqualTo: postProvider.getUserProfile)
                                .orderBy("dateAdded", descending: true)
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      top: 25, bottom: 25),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    String platnUid =
                                        snapshot.data!.docs[index].id;
                                    String userUID =
                                        snapshot.data!.docs[index]['userUID'];
                                    return Container(
                                      margin: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SvgPicture.asset(
                                                        "images/Subtract.svg"),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        snapshot.data!
                                                                    .docs[index]
                                                                ['plantName'] ??
                                                            '',
                                                      ),
                                                    ),
                                                    //insert code here for modal,
                                                    IconButton(
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Container(
                                                              height: 200,
                                                              color:
                                                                  Colors.white,
                                                              child: Center(
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      const Text(
                                                                        "Informations: ",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize: 24.0),
                                                                      ),
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.all(16.0),
                                                                        child:
                                                                            Text(
                                                                          snapshot.data!.docs[index]['plantDescription'] ??
                                                                              '',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.info,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              currentUser == userUID
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder: (_) =>
                                                                  const loadingDialog(
                                                                      message:
                                                                          "Deleting Post"),
                                                            );
                                                            await LivingPlant
                                                                .firebaseFirestore!
                                                                .collection(
                                                                    "plantsCollection")
                                                                .doc(platnUid)
                                                                .delete()
                                                                .then(
                                                              (value) {
                                                                Navigator.pop(
                                                                    context);
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (_) =>
                                                                      const errorDialog(
                                                                          message:
                                                                              "Plant Was Deleted"),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Text(""),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 25, top: 5),
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['location'],
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0XFFA1A8B9)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 25, top: 5),
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['dateAdded'],
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0XFFA1A8B9)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showingBottomToUp();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey),
                                              child: snapshot.data!.docs[index]
                                                          ['plantUrl'] !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl: snapshot
                                                              .data!.docs[index]
                                                          ['plantUrl'],
                                                    )
                                                  : const CircularProgressIndicator(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
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
          )
        ],
      ),
    );
  }

  showingBottomToUp() {
    var postProvider = Provider.of<postPageProvider>(context, listen: false);
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
                      .where("userUID", isEqualTo: postProvider.getUserProfile)
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
                              String plantDescripiton = snapshot
                                  .data!.docs[index]['plantDescription'];

                              String userTradeTwoFullName =
                                  snapshot.data!.docs[index]['userFullName'];

                              String plantNameTow =
                                  snapshot.data!.docs[index]['plantName'];

                              String locationTowTrade =
                                  snapshot.data!.docs[index]['location'];

                              String plantUrl =
                                  snapshot.data!.docs[index]['plantUrl'];

                              String plantAskedUID =
                                  snapshot.data!.docs[index].id;

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
                                            "${getFirstWords(snapshot.data!.docs[index]['plantDescription'].toString(), 7).toString()}...",
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
                                        checkingUser(
                                            userTradeTwoFullName,
                                            plantNameTow,
                                            locationTowTrade,
                                            plantUrl,
                                            plantAskedUID);
                                      },
                                      child: const Text(
                                        "Want this?",
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

  void checkingUser(String userTradeTwoFullName, String plantNameTow,
      String locationTowTrade, String plantUrl, String plantAskedUID) async {
    var postProvider = Provider.of<postPageProvider>(context, listen: false);
    var tradeProvider = Provider.of<traderProvider>(context, listen: false);

    await LivingPlant.firebaseFirestore!
        .collection('chats')
        .where('users', isEqualTo: {
          "TraderAskedUid": currentUser,
          "TraderAcceptingUid": postProvider.getUserProfile
        })
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              tradeProvider.updateCommonID(querySnapshot.docs.single.id);
              await LivingPlant.firebaseFirestore!
                  .collection("chats")
                  .doc(querySnapshot.docs.single.id)
                  .update({
                'users': {
                  "TraderAskedUid": currentUser,
                  "TraderAcceptingUid": postProvider.getUserProfile
                },
                // Trader Asked
                "TraderAskedUid": currentUser,
                "TraderAskedFullName":
                    "${LivingPlant.sharedPreferences!.getString(LivingPlant.firstName)} ${LivingPlant.sharedPreferences!.getString(LivingPlant.lastName)}",
                "TraderAskedStatus": "Pending",

                // Plants Informations
                "PlantPickedByTraderName": plantNameTow,
                "PlantPickedByTraderUrl": plantUrl,
                "PlantPickedByTraderLocation": locationTowTrade,
                "PlantAskedUid": plantAskedUID.toString(),
                "TradeStatus": "Pending",

                // Trader Accepting
                "TraderAcceptingUid": postProvider.getUserProfile,
                "TraderAcceptingFullName": userTradeTwoFullName,
                "TraderAcceptingStatust": "Pending",

                //////// Empty infomration for the new user
                "PlantPickedByWantingToGiveName": '',
                "PlantPickedByWantingToGiveUrl": '',
                "PlantPickedByWantingToGiveLocation": '',
                "PlantPickedByWantingToGiveUID": '',
              });
              Navigator.pop(context);

              print(chatDocId);
            } else {
              await LivingPlant.firebaseFirestore!.collection("chats").add({
                'users': {
                  "TraderAskedUid": currentUser,
                  "TraderAcceptingUid": postProvider.getUserProfile
                },
                // Trader Asked
                "TraderAskedUid": currentUser,
                "TraderAskedFullName":
                    "${LivingPlant.sharedPreferences!.getString(LivingPlant.firstName)} ${LivingPlant.sharedPreferences!.getString(LivingPlant.lastName)}",
                "TraderAskedStatus": "Pending",

                // Plants Informations
                "PlantPickedByTraderName": plantNameTow,
                "PlantPickedByTraderUrl": plantUrl,
                "PlantPickedByTraderLocation": locationTowTrade,
                "PlantAskedUid": plantAskedUID.toString(),
                "TradeStatus": "Pending",

                // Trader Accepting
                "TraderAcceptingUid": postProvider.getUserProfile,
                "TraderAcceptingFullName": userTradeTwoFullName,
                "TraderAcceptingStatust": "Pending",

                //////// Empty infomration for the new user
                "PlantPickedByWantingToGiveName": '',
                "PlantPickedByWantingToGiveUrl": '',
                "PlantPickedByWantingToGiveLocation": '',
                "PlantPickedByWantingToGiveUID": '',
              }).then(
                (value) {
                  chatDocId = value;
                  value.id;
                  LivingPlant.firebaseFirestore!
                      .collection("chats")
                      .doc(chatDocId)
                      .update({"ChatUID": chatDocId});

                  print("This is the id ${value.id}");
                  tradeProvider.updateCommonID(value.id);
                },
              );
              Navigator.pop(context);
            }
          },
        )
        .catchError(
          (error) {},
        );
  }
}
