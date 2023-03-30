import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/imageRecogntionProvider.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/user/home/PlantRecognitions/imageIdentifiedDetials.dart';
import 'package:living_plant/user/home/PlantRecognitions/module/plantModule.dart'
    as module;
import 'package:living_plant/user/home/homePage.dart';
import 'package:living_plant/user/home/newUserProfile.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:image/image.dart' as ImageProcess;

class IdentifyImagePage extends StatefulWidget {
  const IdentifyImagePage({super.key});

  @override
  State<IdentifyImagePage> createState() => _IdentifyImagePage();
}

class _IdentifyImagePage extends State<IdentifyImagePage> {
  User? user = LivingPlant.firebaseAuth!.currentUser;
  var finalDays;
  int currentIndex = 0;
  String? data;

// calling data from sharedprefrences

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();

  @override
  Widget build(BuildContext context) {
    var getingImageProvider = Provider.of<imageRecogntionProvider>(context);
    print(
        "This is the image picked ${getingImageProvider.imagePickedGetting!.path}");
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0XFFE5E5E5),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Image(
                image: FileImage(
                  File(getingImageProvider.imagePickedGetting!.path),
                ),
                fit: BoxFit.fitWidth,
              ),
              ElevatedButton(
                onPressed: () {
                  identifyPlant();
                },
                child: const Text("Identify"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
    );
  }

  //Checking if ti's plant of not
  checking(bool isplant) {
    if (isplant == true) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ImageIdentifiedDetials()));
    } else {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (_) => const errorDialog(
              message: "This doesn't seem like a plant? Try Again."));
    }
  }

  identifyPlant() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const loadingDialog(message: "Identifying plant... Please wait."),
    );
    requestingData();
  }

  Future requestingData() async {
    //Provider
    var getingImageProvider =
        Provider.of<imageRecogntionProvider>(context, listen: false);

    // Providr for API
    var APIProvidcer = Provider.of<postPageProvider>(context, listen: false);

    // Getting the image using the provider
    var imageFromProvider = getingImageProvider.imagePickedGetting!.path;

    File file = File(imageFromProvider);
    final imageFile = ImageProcess.decodeImage(
      file.readAsBytesSync(),
    );

    // Image in BS4
    String base64Image = base64Encode(ImageProcess.encodePng(imageFile!));

    // This is for the API
    var client = http.Client();
    var url = Uri.parse("https://api.plant.id/v2/identify");
    // Getting Data
    var gettingAPI = await LivingPlant.firebaseFirestore!
        .collection("api")
        .doc("HEmMnpsEKMje2B6TUSYU")
        .get();

    print(gettingAPI.data()!['api']);
    String api = gettingAPI.data()!['api'];
    var headers = {
      "Content-Type": "application/json",
      "Api-Key": api,
    };

    final Map body = {
      "images": [base64Image],
      "modifiers": ["similar_images"],
      "plant_details": [
        "common_names",
        "url",
        "wiki_description",
        "taxonomy",
        "synonyms"
      ],
      "suggestions": ["synonyms", "taxonomy"]
    };

    try {
      final response =
          await client.post(url, body: json.encode(body), headers: headers);
      if (response.statusCode == 200) {
        var responses =
            await getingImageProvider.updatetingDataResponse(response.body);
        module.Welcome model = module.welcomeFromJson(response.body);

        bool probability = model.isPlant!;
        checking(probability);

        print("This is the probability ${probability}");
      } else {
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (_) => errorDialog(
            message: "Response is ${response.body}",
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (_) => errorDialog(
          message: error.toString(),
        ),
      );
      Navigator.pop(context);
    }
  }
}
