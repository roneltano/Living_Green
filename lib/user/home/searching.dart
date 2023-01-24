import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/main.dart';
import 'package:carousel_slider/carousel_slider.dart';

class searchingPage extends StatefulWidget {
  const searchingPage({super.key});

  @override
  State<searchingPage> createState() => _searchingPageState();
}

class _searchingPageState extends State<searchingPage> {
  String searching = "";
  List? newList;
  List? oldList;
  String? plantName;
  var chatDocId;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade300,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 12,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          newList = oldList!
                              .where((element) =>
                                  plantName!.toLowerCase().contains(searching))
                              .toList();
                          searching = value;
                        });
                        // updateINform(value);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: LivingPlant.primaryColor,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.transparent, width: 2.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Search',
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                    stream: LivingPlant.firebaseFirestore!
                        .collection("plantsCollection")
                        .where("userUID", isNotEqualTo: currentUser)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // Update Information

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        oldList = snapshot.data!.docs;
                        newList = List.from(snapshot.data!.docs);
                        return GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 256,
                          ),
                          shrinkWrap: true,
                          itemCount: newList!.length,
                          itemBuilder: (context, index) {
                            plantName = snapshot.data!.docs[index]['plantName'];

                            if (plantName!
                                .toLowerCase()
                                .startsWith(searching)) {
                              return GestureDetector(
                                onTap: () {
                                  showingData();
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
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
                                      Text(
                                        snapshot.data!.docs[index]['plantName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data!.docs[index]
                                          ['userFullName']),
                                      Text(snapshot.data!.docs[index]
                                          ['location']),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const Text('');
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showingData() {
    // var postProvider = Provider.of<postPageProvider>(context, listen: false);
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
                      .where("userUID", isNotEqualTo: currentUser)
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

                              String userOwnThePlants =
                                  snapshot.data!.docs[index]['userUID'];

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
                                    Text(userTradeTwoFullName),
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
                                            plantAskedUID,
                                            userOwnThePlants);
                                      },
                                      child: const Text(
                                        "Want This?",
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

  checkingUser(
      String userTradeTwoFullName,
      String plantNameTow,
      String locationTowTrade,
      String plantUrl,
      String plantAskedUID,
      String userOwnThePlants) async {
    await LivingPlant.firebaseFirestore!
        .collection('chats')
        .where('users', isEqualTo: {
          "TraderAskedUid": currentUser,
          "TraderAcceptingUid": userOwnThePlants,
        })
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              // tradeProvider.updateCommonID(querySnapshot.docs.single.id);
              await LivingPlant.firebaseFirestore!
                  .collection("chats")
                  .doc(querySnapshot.docs.single.id)
                  .update({
                'users': {
                  "TraderAskedUid": currentUser,
                  "TraderAcceptingUid": userOwnThePlants
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
                "TraderAcceptingUid": userOwnThePlants,
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
                  "TraderAcceptingUid": userOwnThePlants
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
                "TraderAcceptingUid": userOwnThePlants,
                "TraderAcceptingFullName": userTradeTwoFullName,
                "TraderAcceptingStatust": "Pending",

                //////// Empty infomration for the new user
                "PlantPickedByWantingToGiveName": '',
                "PlantPickedByWantingToGiveUrl": '',
                "PlantPickedByWantingToGiveLocation": '',
                "PlantPickedByWantingToGiveUID": '',

                "ChatUID": '',
              }).then(
                (value) async {
                  chatDocId = value.id;
                  value.id;
                  await LivingPlant.firebaseFirestore!
                      .collection("chats")
                      .doc(chatDocId)
                      .update({"ChatUID": chatDocId});

                  print("This is the id ${value.id}");
                  // tradeProvider.updateCommonID(value.id);
                },
              );

              // Route route = MaterialPageRoute(builder: (_) => customChat());
              // Navigator.push(context, route);
              Navigator.pop(context);
            }
          },
        )
        .catchError(
          (error) {},
        );
  }
}
