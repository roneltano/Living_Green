import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart' as config;
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:living_plant/user/home/myPlants.dart';
import 'package:living_plant/widgets/topNav.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as dateFromat;

import '../../DialogBox/errorDialog.dart';
import '../../providers/postPageProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  User? user = config.LivingPlant.firebaseAuth!.currentUser;
  var finalDays;

  var imageGetting =
      config.LivingPlant.sharedPreferences!.getString(config.LivingPlant.image);
  var firstName = config.LivingPlant.sharedPreferences!
      .getString(config.LivingPlant.firstName);
  var lastName = config.LivingPlant.sharedPreferences!
      .getString(config.LivingPlant.lastName);

  String? currentUser = LivingPlant.firebaseAuth!.currentUser!.uid;

  String searching = '';

  final PageStorageBucket bucket = PageStorageBucket();
  TextEditingController _comment = TextEditingController();
  Widget currentScreen = const UserLogin();

  var expertOrNot = config.LivingPlant.sharedPreferences!
      .getString(config.LivingPlant.expertMark.toString());

  @override
  void dispose() {
    _comment;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFE5E5E5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const TopNav(),
                  postsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget postsWidget() {
    var postProvider = Provider.of<postPageProvider>(context, listen: true);
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: config.LivingPlant.firebaseFirestore!
                    .collection("posts")
                    .orderBy("dateNow", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var netwrokImage =
                            snapshot.data!.docs[index]['postedImageUrl'];
                        String? postedByImageURL =
                            snapshot.data!.docs[index]['postedByImageURL'];
                        var postUID = snapshot.data!.docs[index].id;
                        var postedBy =
                            snapshot.data!.docs[index]['postedByUid'];
                        var experOrNot = snapshot.data!.docs[index]['Expert'];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 22),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                postedBy != currentUser
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          postProvider
                                                              .updateUserProfile(
                                                                  postedBy);
                                                          Route route =
                                                              MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      const MyPlants());
                                                          Navigator.push(
                                                              context, route);
                                                          debugPrint(
                                                              'posted by: $postedBy');
                                                        },
                                                        child: imageGetting!
                                                                    .length >
                                                                5
                                                            ? CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black12,
                                                                backgroundImage: postedByImageURL !=
                                                                        "null"
                                                                    ? NetworkImage(
                                                                        postedByImageURL!,
                                                                      )
                                                                    : NetworkImage(
                                                                        "https/www.com"),
                                                                radius: 23,
                                                              )
                                                            : const CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black12,
                                                                radius: 23,
                                                              ),
                                                      )
                                                    : imageGetting!.length > 5
                                                        ? const CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black12,
                                                            // backgroundImage:
                                                            //     NetworkImage(
                                                            //   postedByImageURL,
                                                            // ),
                                                            radius: 23,
                                                          )
                                                        : const CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black12,
                                                            radius: 23,
                                                          ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'postedByName']
                                                                  .toString(),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            experOrNot ==
                                                                    "expert"
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_circle_rounded,
                                                                    color: Colors
                                                                        .green,
                                                                    size: 15,
                                                                  )
                                                                : const Text(
                                                                    ""),
                                                          ],
                                                        ),
                                                        Text(
                                                          snapshot
                                                              .data!
                                                              .docs[index][
                                                                  'postAddress']
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 7,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  const loadingDialog(
                                                      message: ""),
                                            );
                                            await config
                                                .LivingPlant.firebaseFirestore!
                                                .collection("posts")
                                                .doc(snapshot
                                                    .data!.docs[index].id)
                                                .update({
                                              "reported": true,
                                            }).then(
                                              (value) {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => const errorDialog(
                                                      message:
                                                          "Post was reported, admin will check"),
                                                );
                                              },
                                            );
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                              EdgeInsets.zero,
                                            ),
                                          ),
                                          child: const Text(
                                            "Report",
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 2),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${snapshot.data!.docs[index]['postMessage']}",
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        CachedNetworkImage(
                                            imageUrl: netwrokImage),
                                        const SizedBox(
                                          height: 15,
                                        ),

                                        // Starting of commnets
                                        TextField(
                                          //whatever we write stores in the controller
                                          controller: _comment,
                                          // onChanged: (commentValue) =>
                                          //     postProvider
                                          //         .updateComment(commentValue),
                                          obscureText: false,
                                          autofocus: false,
                                          cursorColor: const Color(0XFFD9D9D9),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            isCollapsed: false,
                                            isDense: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(17),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Color(0XFFD9D9D9),
                                              ),
                                            ),
                                            hintText: "What are your thoughts?",
                                            hintStyle:
                                                const TextStyle(fontSize: 10),
                                            suffixStyle: const TextStyle(
                                                color: config
                                                    .LivingPlant.primaryColor),
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.send),
                                              onPressed: () {
                                                sendComment(postUID);
                                              },
                                            ),
                                            border: InputBorder.none,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(17),
                                              borderSide: const BorderSide(
                                                width: 1,
                                                color: Color(0XFFD9D9D9),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // comment(),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StreamBuilder<QuerySnapshot>(
                                              stream: config.LivingPlant
                                                  .firebaseFirestore!
                                                  .collection("posts")
                                                  .doc(postUID)
                                                  .collection("comments")
                                                  .orderBy("commentCount",
                                                      descending: true)
                                                  .snapshots(),
                                              builder:
                                                  (context, commentSnapshot) {
                                                if (!commentSnapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else if (commentSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                } else {
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxHeight: 200),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: commentSnapshot
                                                          .data!.docs.length,
                                                      itemBuilder: (context,
                                                          CommentIndex) {
                                                        String CommentUID =
                                                            commentSnapshot
                                                                .data!
                                                                .docs[
                                                                    CommentIndex]
                                                                .id;

                                                        var CommentCount =
                                                            commentSnapshot.data!
                                                                        .docs[
                                                                    CommentIndex]
                                                                [
                                                                'commentCount'];

                                                        var votedAlready =
                                                            commentSnapshot.data!
                                                                        .docs[
                                                                    CommentIndex]
                                                                [
                                                                'votedAlready'];

                                                        var exprtOrNot =
                                                            commentSnapshot.data!
                                                                        .docs[
                                                                    CommentIndex]
                                                                ['Expert'];

                                                        var userVored =
                                                            commentSnapshot.data!
                                                                        .docs[
                                                                    CommentIndex]
                                                                ['userVored'];

                                                        return Container(
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0XFFE5E5E5),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6)),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  imageGetting !=
                                                                          null
                                                                      ? CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.black12,
                                                                          backgroundImage: imageGetting != null
                                                                              ? NetworkImage(commentSnapshot.data!.docs[CommentIndex]['CommentedProfileImage']!)
                                                                              : null,
                                                                          radius:
                                                                              23,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          commentSnapshot
                                                                              .data!
                                                                              .docs[CommentIndex]['CommentedProfileImage'],
                                                                          height:
                                                                              90,
                                                                        ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(commentSnapshot
                                                                          .data!
                                                                          .docs[
                                                                              CommentIndex]
                                                                              [
                                                                              'CommentedByName']
                                                                          .toString()),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      exprtOrNot ==
                                                                              "expert"
                                                                          ? const Icon(
                                                                              Icons.check_circle_rounded,
                                                                              color: Colors.green,
                                                                              size: 15,
                                                                            )
                                                                          : const Text(
                                                                              ""),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10,
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            15),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Column(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                ///////////////////// Votteing UP

                                                                                // if (votedAlready == false) {
                                                                                if (userVored != currentUser) {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (_) => const loadingDialog(message: ""),
                                                                                  );
                                                                                  await config.LivingPlant.firebaseFirestore!.collection("posts").doc(postUID).collection("comments").doc(CommentUID).update({
                                                                                    "commentCount": CommentCount! + 1,
                                                                                    "votedAlready": true,
                                                                                    "userVored": currentUser,
                                                                                  }).then((value) {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                }
                                                                                ////////////////////
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                "images/icons/up.svg",
                                                                                width: 17,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              commentSnapshot.data!.docs[CommentIndex]['commentCount'].toString(),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () async {
                                                                                ///////////////////// Votteing Down
                                                                                if (userVored != currentUser) {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (_) => const loadingDialog(message: ""),
                                                                                  );
                                                                                  await config.LivingPlant.firebaseFirestore!.collection("posts").doc(postUID).collection("comments").doc(CommentUID).update({
                                                                                    "commentCount": CommentCount! - 1,
                                                                                    "votedAlready": true,
                                                                                    "userVored": currentUser,
                                                                                  }).then((value) {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                }
                                                                                ////////////////////
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                "images/icons/down.svg",
                                                                                width: 17,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            commentSnapshot.data!.docs[CommentIndex]['comment'].toString(),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendComment(String PostUID) {
    var postProvider = Provider.of<postPageProvider>(context, listen: false);
    _comment.text.isNotEmpty ? savingImagePost(PostUID) : showErrorMessage();
  }

  showErrorMessage() {
    return showDialog(
      context: context,
      builder: (_) => const errorDialog(message: "Comment can't be empty"),
    );
  }

  savingImagePost(String POSTUID) async {
    showDialog(
      context: context,
      builder: (_) => const loadingDialog(
        message: "Saving Comment",
      ),
    );

    savingPost(POSTUID);
  }

  Future savingPost(String POSTUID) async {
    var postProvider = Provider.of<postPageProvider>(context, listen: false);
    // FocusScope.of(context).unfocus();

    User? user = config.LivingPlant.firebaseAuth!.currentUser;
    String currentUser = user!.uid;

    config.LivingPlant.firebaseFirestore!
        .collection("posts")
        .doc(POSTUID)
        .collection("comments")
        .add({
      "CommentedByUid": currentUser.toString().trim(),
      "CommentedByName": "$firstName $lastName",
      "CommentedProfileImage": imageGetting.toString(),
      "comment": _comment.text.trim(),
      "postUID": POSTUID,
      "CommentDate":
          dateFromat.DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
      "commentCount": 0,
      "votedAlready": false,
      "upOrDOwn": false,
      "userVored": currentUser,
      "Expert": expertOrNot == "expert" ? "expert" : "user",
    }).then((value) {
      // setState(() {
      //   _comment.text = '';
      // });
      _comment.clear();
      postProvider.updateComment('');

      Navigator.pop(context);
    });
  }
}
