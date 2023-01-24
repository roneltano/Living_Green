import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/providers/imageRecogntionProvider.dart';
import 'package:living_plant/providers/postPageProvider.dart';
import 'package:living_plant/user/home/PlantRecognitions/module/plantModule.dart'
    as module;
import 'package:intl/intl.dart' as forDate;
import 'package:living_plant/user/home/bottomAndUp.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class ImageIdentifiedDetials extends StatefulWidget {
  const ImageIdentifiedDetials({super.key});

  @override
  State<ImageIdentifiedDetials> createState() => _ImageIdentifiedDetialsState();
}

class _ImageIdentifiedDetialsState extends State<ImageIdentifiedDetials> {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';
  Position? position;
  List<Placemark>? placeMare;

  @override
  Widget build(BuildContext context) {
    var gettingDataFromPriovider =
        Provider.of<imageRecogntionProvider>(context, listen: true);

    module.Welcome model =
        module.welcomeFromJson(gettingDataFromPriovider.gettingResponseData);

    var plantImage = model.images![0].url.toString();

    String? getFirstWords(String? sentence, int wordCounts) {
      return sentence?.split(" ").sublist(0, wordCounts).join(" ");
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0XFFD9D9D9),
                  ),
                  child: Column(
                    children: [
                      plantImage.isNotEmpty
                          ? Image(
                              image: NetworkImage(
                                plantImage,
                              ),
                            )
                          : const CircularProgressIndicator(),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        model.suggestions![0].plantName.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${model.isPlantProbability.toString().substring(2, 4)}%",
                  style: const TextStyle(color: LivingPlant.primaryColor),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 30, left: 30, top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description"),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.suggestions![0].plantDetails!.wikiDescription!
                              .value
                              .toString(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Taxonomy"),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text("Kingdom:"),
                            Text(
                              model.suggestions![0].plantDetails!.taxonomy!
                                  .kingdom
                                  .toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Phylum:"),
                            Text(
                              model.suggestions![0].plantDetails!.taxonomy!
                                  .phylum
                                  .toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Class:"),
                            Text(
                              model.suggestions![0].plantDetails!.taxonomy!
                                  .taxonomyClass!
                                  .toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Order:"),
                            Text(
                              model
                                  .suggestions![0].plantDetails!.taxonomy!.order
                                  .toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Family:"),
                            Text(
                              model.suggestions![0].plantDetails!.taxonomy!
                                  .family
                                  .toString(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Genus:"),
                            Text(model.suggestions![0].plantDetails!
                                .structuredName!.genus
                                .toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: const Divider(
                          color: Color(0XFFD9D9D9),
                          height: 2,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0XFFD9D9D9),
                      ),
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, top: 5, bottom: 5),
                      child: const Text("Possible Identities"),
                    ),
                    Expanded(
                      child: Container(
                        child: const Divider(
                          color: Color(0XFFD9D9D9),
                          height: 2,
                          thickness: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  itemCount: model.suggestions!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var gettingID = model.suggestions![index].id;
                    return Container(
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, top: 7, bottom: 7),
                      margin: const EdgeInsets.only(
                          right: 10, left: 10, top: 7, bottom: 7),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0XFF000000),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${model.suggestions![index].probability.toString().substring(2, 4)}%",
                                          style: const TextStyle(
                                              color: LivingPlant.primaryColor),
                                        ),
                                        // Text(
                                        //   model.suggestions![index].confirmed
                                        //       .toString(),
                                        // ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(2),
                                          width: 60,
                                          child: plantImage.isNotEmpty
                                              ? Image(
                                                  image: NetworkImage(
                                                    model.suggestions![index]
                                                        .similarImages![0].url
                                                        .toString(),
                                                  ),
                                                )
                                              : const CircularProgressIndicator(),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(2),
                                          width: 60,
                                          child: plantImage.isNotEmpty
                                              ? Image(
                                                  image: NetworkImage(
                                                    model.suggestions![index]
                                                        .similarImages![1].url
                                                        .toString(),
                                                  ),
                                                )
                                              : const CircularProgressIndicator(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            model.suggestions![index].plantName
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 13),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            "${getFirstWords(model.suggestions![index].plantDetails!.wikiDescription?.value.toString(), 10)}...",
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.search,
                                                  size: 13,
                                                  color:
                                                      LivingPlant.primaryColor,
                                                ),
                                                Text(
                                                  "Google",
                                                  style: TextStyle(
                                                    color: LivingPlant
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              var list = model
                                                  .suggestions![index]
                                                  .plantName;
                                              showDetials(list);
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.info,
                                                  size: 13,
                                                  color:
                                                      LivingPlant.primaryColor,
                                                ),
                                                Text(
                                                  "Details",
                                                  style: TextStyle(
                                                    color: LivingPlant
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    askThePropleFunction();
                  },
                  child: const Text("Ask the people"),
                ),
                ElevatedButton(
                  onPressed: () {
                    currentLocation();
                  },
                  child: const Text("Save to collection"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//getCurrentLocation
  currentLocation() async {
    Position newPostition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).catchError((error) {
      saveToEcolleciton("no locaion");
    });
    position = newPostition;
    placeMare =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark mark = placeMare![0];
    String currentLocation =
        '${mark.subLocality} ${mark.locality}, ${mark.subAdministrativeArea}';

    print(currentLocation);
    saveToEcolleciton(currentLocation);
  }

  showDetials(var detailsID) {
    var gettingDataFromPriovider =
        Provider.of<imageRecogntionProvider>(context, listen: false);

    module.Welcome model =
        module.welcomeFromJson(gettingDataFromPriovider.gettingResponseData);

    model.suggestions?.forEach((element) {});

    print(detailsID);

    // Route route = MaterialPageRoute(
    //   builder: (_) => eachPlatnDetials(
    //     ID: ID,
    //   ),
    // );
    // Navigator.push(context, route);
  }

  // Save to collection Function
  saveToEcolleciton(String currentLocation) {
    User? user = LivingPlant.firebaseAuth!.currentUser;
    String currentUser = user!.uid;

    var gettingDataFromPriovider =
        Provider.of<imageRecogntionProvider>(context, listen: false);

    module.Welcome model =
        module.welcomeFromJson(gettingDataFromPriovider.gettingResponseData);
    showDialog(
      context: context,
      builder: (_) {
        return const loadingDialog(message: "Saving to collection");
      },
    );

    LivingPlant.firebaseFirestore!.collection("plantsCollection").add({
      "plantName": model.suggestions![0].plantName.toString(),
      "plantUrl": model.images![0].url.toString(),
      "dateAdded": forDate.DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "plantDescription":
          model.suggestions![0].plantDetails!.wikiDescription?.value.toString(),
      "userUID": currentUser,
      "userFullName":
          "${LivingPlant.sharedPreferences!.getString(LivingPlant.firstName)} ${LivingPlant.sharedPreferences!.getString(LivingPlant.lastName)} ",
      "location": currentLocation,
    }).then((value) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (_) => const bottomAndUp());
      Navigator.pushReplacement(context, route);
    });
  }

  // Asking the people Functions
  askThePropleFunction() async {
    // String imageDownloadUrl = await uploadingItemImage(widget.imageXfile);

    // try {
    //   var imageId = await ImageDownloader.downloadImage(url).then((value) {
    //     if (value != null) {
    //       showDialog(
    //         context: context,
    //         builder: (_) =>
    //             const errorDialog(message: "Image Downloaded Sussfully"),
    //       );
    //     }
    //   });
    //   if (imageId == null) {
    //     return;
    //   }
    // } on PlatformException catch (error) {
    //   print("This is the Error ${error}");
    // }

    var gettingDataFromPriovider =
        Provider.of<imageRecogntionProvider>(context, listen: false);

    module.Welcome model =
        module.welcomeFromJson(gettingDataFromPriovider.gettingResponseData);
    var providerPage = Provider.of<postPageProvider>(context, listen: false);

    providerPage.updateingImage(XFile(model.images![0].url!));
    providerPage.updatePostMessage(model.suggestions![0].plantName.toString());

    print("This is the XFile ${providerPage.xFileGetting!.path}");
    print("This is the XFile ${providerPage.plantName}");

    Navigator.pop(context);
    Route route = MaterialPageRoute(builder: (_) => const bottomAndUp());
    Navigator.pushReplacement(context, route);
  }
}
