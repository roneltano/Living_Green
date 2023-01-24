import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:image_picker/image_picker.dart' as pickingImage;
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/user/home/PlantRecognitions/IdentifyImagePage.dart';
import 'package:provider/provider.dart';

class imageRecognitionBottom extends StatefulWidget {
  const imageRecognitionBottom({super.key});

  @override
  State<imageRecognitionBottom> createState() => _imageRecognitionBottom();
}

class _imageRecognitionBottom extends State<imageRecognitionBottom> {
  User? user = LivingPlant.firebaseAuth!.currentUser;
  var finalDays;
  int currentIndex = 0;

// calling data from sharedprefrences
  var imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image);
  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const imageUploadChoice();

  pickingImage.XFile? ImageXFile;
  String? postImageUrl;
  File? ImageedPicked;

// posign something
  final TextEditingController PostDetials = TextEditingController();
  final pickingImage.ImagePicker _picker = pickingImage.ImagePicker();

  @override
  Widget build(BuildContext context) {
    var gettingProvider = Provider.of<postPageProvider>;

    return Scaffold(
      backgroundColor: const Color(0XFFE5E5E5),
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: const Color(0XFF0FA958),
      //   child: const Icon(
      //     Typicons.camera_outline,
      //     size: 35,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 10,
      //   child: SizedBox(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             MaterialButton(
      //               minWidth: 130,
      //               onPressed: () {
      //                 setState(() {
      //                   currentScreen = const HomePage();
      //                   currentIndex = 0;
      //                 });
      //               },
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.home,
      //                     size: 35,
      //                     color: currentIndex == 0
      //                         ? const Color(0XFF2DDA93)
      //                         : const Color(0XFFD2D2D2),
      //                   ),
      //                   Text(
      //                     "Home",
      //                     style: TextStyle(
      //                       color: currentIndex == 0
      //                           ? const Color(0XFF2DDA93)
      //                           : const Color(0XFFD2D2D2),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             MaterialButton(
      //               minWidth: 130,
      //               onPressed: () {
      //                 setState(() {
      //                   currentScreen = const NewUserProfile();
      //                   currentIndex = 1;
      //                 });
      //               },
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   Icon(
      //                     Icons.person,
      //                     size: 35,
      //                     color: currentIndex == 1
      //                         ? const Color(0XFF2DDA93)
      //                         : const Color(0XFFD2D2D2),
      //                   ),
      //                   Text(
      //                     "Profile",
      //                     style: TextStyle(
      //                       color: currentIndex == 1
      //                           ? const Color(0XFF2DDA93)
      //                           : const Color(0XFFD2D2D2),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future checkingEmpty() async {
    PostDetials.text.isNotEmpty && imageGetting != null
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
    var providerPage = Provider.of<postPageProvider>(context, listen: false);
    var imageChanged = providerPage.xFileGetting;

    showDialog(
      context: context,
      builder: (_) => loadingDialog(
        message: mesg,
      ),
    );

    if (imageChanged != null) {
      String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference reference =
          LivingPlant.firebaseStorage!.ref().child("posts").child(imageName);
      UploadTask uploadTask = reference.putFile(
        File(imageChanged.path),
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
    String currentUser = user!.uid;

    LivingPlant.firebaseFirestore!.collection("posts").add({
      "postedByUid": currentUser.toString().trim(),
      "postedByName": "$firstName $lastName",
      "postMessage": PostDetials.text.trim(),
      "postedImageUrl": postImageUrl,
      "postedDate": DateTime.now(),
    }).then((value) {
      print("This is the ID of the Post ${value.id}");
      LivingPlant.firebaseFirestore!.collection("posts").doc(value.id).update({
        "postUID": value.id,
      });
      Navigator.pop(context);
    });
  }
}
