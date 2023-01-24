import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/traderProvider.dart';
import 'package:living_plant/user/home/chats/tradeHistory/tradeHistoryChat.dart';
import 'package:provider/provider.dart';

class tradeHistoryFinished extends StatefulWidget {
  tradeHistoryFinished({Key? key}) : super(key: key);

  @override
  _tradeHistoryFinished createState() => _tradeHistoryFinished();
}

class _tradeHistoryFinished extends State<tradeHistoryFinished> {
  final currentUserId = LivingPlant.firebaseAuth!.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    var tradeProvider = Provider.of<traderProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finished Trades"),
        centerTitle: true,
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
                          .where("TradeStatus", isEqualTo: "Accepted")
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
                                                        child: Image.network(
                                                          snapshot
                                                              .data!
                                                              .docs[index][
                                                                  'PlantPickedByTraderUrl']
                                                              .toString(),
                                                          fit: BoxFit.fill,
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
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${snapshot.data!.docs[index]['TraderAskedFullName']} Traded ",
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color:
                                                      LivingPlant.primaryColor,
                                                ),
                                                Text(
                                                    "with ${snapshot.data!.docs[index]['TraderAcceptingFullName']}"),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${snapshot.data!.docs[index]['PlantPickedByWantingToGiveName']} Traded ",
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color:
                                                      LivingPlant.primaryColor,
                                                ),
                                                Text(
                                                  "with ${snapshot.data!.docs[index]['PlantPickedByTraderName']}",
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              print(snapshot
                                                  .data!.docs[index].id);
                                              tradeProvider.updateChatUid(
                                                  snapshot
                                                      .data!.docs[index].id);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      tradeHisotryChat(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: const StadiumBorder()),
                                            child: const Text("Check Chat"),
                                          ),
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
}
