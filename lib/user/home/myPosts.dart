import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dateFixing;
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:flutter/material.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPosts();
}

// This Page will show The User Donations
class _MyPosts extends State<MyPosts> {
  User? user = LivingPlant.firebaseAuth!.currentUser;
  @override
  Widget build(BuildContext context) {
    String currentUser = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posts"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: LivingPlant.primaryColor,
            child: Row(
              children: [],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: LivingPlant.firebaseFirestore!
                  .collection("posts")
                  .where("postedByUid", isEqualTo: currentUser)
                  .orderBy("postedDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String imageGetting =
                              snapshot.data!.docs[index]['postedByImageURL'];

                          String gettingImage = snapshot
                              .data!.docs[index]['postedImageUrl']
                              .toString();

                          // String userStatus = snapshot
                          //     .data!.docs[index]['accountStatus']
                          //     .toString();
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 206, 205, 205),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                imageGetting.length > 5
                                    ? CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        backgroundImage:
                                            NetworkImage(imageGetting),
                                        radius: 30,
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: Colors.black12,
                                        radius: 30,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("The Posts: "),
                                        Expanded(
                                          child: Text(
                                            "${snapshot.data!.docs[index]['postMessage']}",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Posted By: ',
                                        ),
                                        Text(
                                          snapshot
                                              .data!.docs[index]['postedByName']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Date Posted: ',
                                        ),
                                        Text(
                                          snapshot
                                              .data!.docs[index]['postedDate']
                                              .toString(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 300,
                                      child: gettingImage.length > 5
                                          ? Image.network(
                                              snapshot.data!.docs[index]
                                                  ['postedImageUrl'],
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.black12,
                                              backgroundImage:
                                                  NetworkImage(gettingImage),
                                              radius: 30,
                                            ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          deletePost(
                                              snapshot.data!.docs[index].id);
                                        },
                                        child: const Text("Delete Post?"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Date

// accept functoin
  deletePost(String postUID) async {
    showDialog(
      context: context,
      builder: (_) => const loadingDialog(message: "Deleting Post"),
    );
    await LivingPlant.firebaseFirestore!
        .collection("posts")
        .doc(postUID)
        .delete()
        .then((value) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (_) => const errorDialog(message: "Post Was Deleted"));
    });
  }
}
