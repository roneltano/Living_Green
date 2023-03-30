import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as pickingImage;
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/user/home/homePage.dart';
import 'package:living_plant/user/home/newUserProfile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as dateFormat;

class bottomAndUp extends StatefulWidget {
  const bottomAndUp({super.key});

  @override
  State<bottomAndUp> createState() => _bottomAndUp();
}

class _bottomAndUp extends State<bottomAndUp> {
  User? user = LivingPlant.firebaseAuth!.currentUser;
  int currentIndex = 0;

// calling data from sharedprefrences
  var imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image);
  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);
  var address = LivingPlant.sharedPreferences!.getString(LivingPlant.address);

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();

  pickingImage.XFile? ImageXFile;
  String? postImageUrl;
  File? ImageedPicked;
  var imagePickedFromGallary;
  var imageFromAskPeople;
  String? plantName;

  var expertOrNot = LivingPlant.sharedPreferences!
      .getString(LivingPlant.expertMark.toString());

// posign something
  final TextEditingController PostDetials = TextEditingController();
  final pickingImage.ImagePicker _picker = pickingImage.ImagePicker();

  @override
  void dispose() {
    PostDetials;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0XFFE5E5E5),
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            circleButton();
          },
          backgroundColor: const Color(0XFF48A2F5),
          child: const Icon(
            Icons.add,
            size: 35,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 130,
                      onPressed: () {
                        setState(() {
                          currentScreen = const HomePage();
                          currentIndex = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 35,
                            color: currentIndex == 0
                                ? const Color(0XFF2DDA93)
                                : const Color(0XFFD2D2D2),
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                              color: currentIndex == 0
                                  ? const Color(0XFF2DDA93)
                                  : const Color(0XFFD2D2D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 130,
                      onPressed: () {
                        setState(() {
                          currentScreen = const NewUserProfile();
                          currentIndex = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            size: 35,
                            color: currentIndex == 1
                                ? const Color(0XFF2DDA93)
                                : const Color(0XFFD2D2D2),
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                              color: currentIndex == 1
                                  ? const Color(0XFF2DDA93)
                                  : const Color(0XFFD2D2D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Picking Image
  pickingImageFromGallery() async {
    var providerPage = Provider.of<postPageProvider>(context, listen: false);
    ImageXFile =
        await _picker.pickImage(source: pickingImage.ImageSource.gallery);
    providerPage.updateingImage(ImageXFile!);
    Navigator.of(context).pop();
    await circleButton();
  }

  circleButton() async {
    ///////////////////
    var providerPage = Provider.of<postPageProvider>(context, listen: false);
    // Gallery
    if (imagePickedFromGallary.toString().isNotEmpty) {
      imagePickedFromGallary = providerPage.xFileGetting?.path;
    }
    // Ask People
    imageFromAskPeople = providerPage.xFileGetting?.path;
    // Ask Name
    plantName = providerPage.postMessage.toString();

    print("This is the image From Asked People ${imageFromAskPeople}");

    if (plantName != null) {
      PostDetials.text = providerPage.postMessage.toString();
    }
    if (imageFromAskPeople != null) {}

    //////////////////
    final sliderValue = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(0),
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          "Create Post",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(),
                        Row(
                          children: [
                            imageGetting!.length > 5
                                ? CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    backgroundImage: imageGetting != null
                                        ? NetworkImage(imageGetting!)
                                        : null,
                                    radius: 23,
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
                                Text(
                                  "$firstName $lastName",
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                const Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    child: TextField(
                      controller: PostDetials,
                      onChanged: (value) =>
                          providerPage.updatePostMessage(value),
                      obscureText: false,
                      cursorColor: const Color(0XFFD9D9D9),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        isCollapsed: false,
                        isDense: true,
                        hintText: "What’s on your mind, $firstName?",
                        hintStyle: const TextStyle(fontSize: 10),
                        suffixStyle:
                            const TextStyle(color: LivingPlant.primaryColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Text("Add to your post"),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () async {
                                pickingImageFromGallery();
                              },
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.image),
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.person),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  imageFromAskPeople.toString().startsWith("http")
                      // This is Image Picked
                      ? SizedBox(
                          child: imageFromAskPeople != null
                              ? SizedBox(
                                  height: 100,
                                  child: Image.network(
                                    imageFromAskPeople,
                                  ),
                                )
                              : null,
                        )
                      // This is Network Image
                      : SizedBox(
                          child: imagePickedFromGallary != null
                              ? SizedBox(
                                  height: 100,
                                  child: Image(
                                    image: FileImage(
                                      File(imagePickedFromGallary),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        checkingEmpty();
                      },
                      child: const Text("Post"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future checkingEmpty() async {
    var providerPage = Provider.of<postPageProvider>(context, listen: false);
    providerPage.postMessage.toString().isNotEmpty && imageGetting != null
        ? savingImagePost("Uploading Post")
        : showErrorMessage();
  }

  showErrorMessage() {
    return showDialog(
      context: context,
      builder: (_) =>
          const errorDialog(message: "Please Fill up the information"),
    );
  }

  savingImagePost(String mesg) async {
    showDialog(
      context: context,
      builder: (_) => loadingDialog(
        message: mesg,
      ),
    );

    if (imagePickedFromGallary != null &&
        imagePickedFromGallary.toString().startsWith("/")) {
      String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference reference =
          LivingPlant.firebaseStorage!.ref().child("posts").child(imageName);
      UploadTask uploadTask = reference.putFile(
        File(imagePickedFromGallary),
      );
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((postIMageUrl) {
        postImageUrl = postIMageUrl;
      });
    }
    savingPost();
  }

  Future savingPost() async {
    User? user = LivingPlant.firebaseAuth!.currentUser;
    var providerPage = Provider.of<postPageProvider>(context, listen: false);

    print(
        "This is the post image ${LivingPlant.sharedPreferences!.getString(LivingPlant.image)}");

    String currentUser = user!.uid;

    LivingPlant.firebaseFirestore!.collection("posts").add({
      "postedByUid": currentUser.toString().trim(),
      "postedByName": "$firstName $lastName",
      "postedByImageURL":
          LivingPlant.sharedPreferences!.getString(LivingPlant.image),
      "postMessage": providerPage.postMessage.toString().trim(),
      "postedImageUrl": imageFromAskPeople.toString().startsWith("http")
          ? imageFromAskPeople
          : postImageUrl,
      "postedDate":
          dateFormat.DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
      "dateNow": DateTime.now(),
      "postAddress": address,
      "Expert": expertOrNot == "expert" ? "expert" : "user",
    }).then((value) {
      print("This is the ID of the Post ${value.id}");
      LivingPlant.firebaseFirestore!.collection("posts").doc(value.id).update({
        "postUID": value.id,
      });

      Navigator.pop(context);
      providerPage.updateingImage(null);
      providerPage.updatePostMessage('');
    });
    Navigator.pop(context);
  }
}
