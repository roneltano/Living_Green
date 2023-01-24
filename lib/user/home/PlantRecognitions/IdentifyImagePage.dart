import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/imageRecogntionProvider.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:living_plant/user/home/PlantRecognitions/showingImagePage.dart';
import 'package:living_plant/widgets/topNav.dart';
import 'package:provider/provider.dart';

class imageUploadChoice extends StatefulWidget {
  const imageUploadChoice({super.key});

  @override
  State<imageUploadChoice> createState() => _imageUploadChoice();
}

class _imageUploadChoice extends State<imageUploadChoice> {
  User? user = LivingPlant.firebaseAuth!.currentUser;
  var finalDays;
  int currentIndex = 0;

  var imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image);
  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const UserLogin();

  // for the photo
  XFile? imageXfile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var providerPicking =
        Provider.of<imageRecogntionProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: const Color(0XFFE5E5E5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  TopNav(),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Text("Upload from device"),
                            IconButton(
                              onPressed: () async {
                                uploadPhoto();
                              },
                              icon: const Icon(
                                Icons.file_upload_outlined,
                                size: 45,
                              ),
                              padding: const EdgeInsets.all(0),
                              color: LivingPlant.primaryColor,
                            )
                          ],
                        ),
                        const Divider(
                          height: 5,
                          thickness: 1,
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            const Text("Take Photo"),
                            IconButton(
                              onPressed: () {
                                openCamera();
                              },
                              icon: const Icon(
                                Icons.camera_enhance,
                                size: 40,
                              ),
                              padding: const EdgeInsets.all(0),
                              color: LivingPlant.primaryColor,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // goingToUploadImage() {
  //   Route route = MaterialPageRoute(builder: (_) => imageRecognitionBottom());
  //   Navigator.push(context, route);
  // }

  uploadPhoto() async {
    var providerPicking =
        Provider.of<imageRecogntionProvider>(context, listen: false);
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    print("Old path ${imageXfile!.path}");
    providerPicking.updateingImagePicked(imageXfile);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const IdentifyImagePage(),
      ),
    );
  }

  openCamera() async {
    var providerPicking =
        Provider.of<imageRecogntionProvider>(context, listen: false);
    imageXfile = await _picker.pickImage(source: ImageSource.camera);
    print("Old path ${imageXfile!.path}");
    providerPicking.updateingImagePicked(imageXfile);
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const IdentifyImagePage(),
      ),
    );
  }
}
