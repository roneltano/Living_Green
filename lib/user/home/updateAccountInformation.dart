import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/widgets/customTextField.dart';

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({super.key});

  @override
  State<UpdateInformation> createState() => _UpdateInformation();
}

class _UpdateInformation extends State<UpdateInformation> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  User? user = LivingPlant.firebaseAuth!.currentUser;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  String? userType;
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = '';

  Position? position;
  List<Placemark>? placemark;

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  Future pickingImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    _imageUrl = imageXFile!.path;
    setState(() {
      _imageUrl;
    });
  }

  showingDialogChecking() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const loadingDialog(
              message: "Please Wait, Getting your location",
            )).then(
      (value) {},
    );
  }

  // For location
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return await Geolocator.getCurrentPosition();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else {
      showingDialogChecking();
      Position newPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      position = newPosition;
      placemark = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      Placemark pMark = placemark![0];
      String complateAddress =
          '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}';
      address.text = complateAddress;
      Navigator.pop(context);
      return address.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Information"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _imageUrl.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              pickingImage();
                            },
                            child: CircleAvatar(
                              backgroundImage: _imageUrl.isNotEmpty
                                  ? NetworkImage(_imageUrl)
                                  : null,
                              radius: 65,
                            ),
                          )
                        : const Icon(
                            Icons.image,
                            size: 130,
                          ),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                          color: LivingPlant.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 33,
                          letterSpacing: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            customTextField(
                              textEditingController: firstName,
                              hint: "Full Name",
                              icon: const Icon(Icons.person),
                              isSecure: false,
                              enabledEdit: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customTextField(
                              textEditingController: lastName,
                              hint: "Last Name",
                              icon: const Icon(Icons.person),
                              isSecure: false,
                              enabledEdit: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customTextField(
                              textEditingController: email,
                              hint: "Email",
                              icon: const Icon(Icons.email),
                              isSecure: false,
                              enabledEdit: false,
                              textInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customTextField(
                              textEditingController: phoneNumber,
                              hint: "Phone Number",
                              icon: const Icon(Icons.phone),
                              isSecure: false,
                              enabledEdit: true,
                              textInputType: TextInputType.phone,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customTextField(
                              textEditingController: address,
                              hint: "Address",
                              icon: const Icon(Icons.location_on),
                              isSecure: false,
                              enabledEdit: true,
                              textInputType: TextInputType.text,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    _determinePosition();
                                  },
                                  icon: const Icon(Icons.map_rounded),
                                  label: const Text("Get Location")),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updatingData();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: LivingPlant.primaryColor),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Update Date",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
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

  Future<void> gettingData() async {
    String currentUser = LivingPlant.firebaseAuth!.currentUser!.uid;
    await LivingPlant.firebaseFirestore!
        .collection("users")
        .doc(currentUser)
        .get()
        .then((value) {
      if (value.exists) {
        firstName.text = value.data()!['firstName'];
        lastName.text = value.data()!['lastName'];
        email.text = value.data()!['email'];
        phoneNumber.text = value.data()!['mobileNumber'].toString();
        address.text = value.data()!['address'].toString();
        _imageUrl = value.data()!['imageUrl'];
        String userTypeResult = value.data()!['userType'];
        setState(() {
          _imageUrl;
        });
      }
    });
  }

  Future updatingData() async {
    User? currentUser = LivingPlant.firebaseAuth!.currentUser;
    String uid = currentUser!.uid;

    showDialog(
      context: context,
      builder: (c) => const loadingDialog(
        message: "Saving Data...",
      ),
    );

    if (imageXFile != null) {
      String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference reference = LivingPlant.firebaseStorage!
          .ref()
          .child("usseImages")
          .child(imageName);
      UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((imageUrll) {
        _imageUrl = imageUrll;
      });
    }

    await LivingPlant.firebaseFirestore!.collection("users").doc(uid).update({
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "email": email.text.trim(),
      "mobileNumber": int.parse(phoneNumber.text.trim()),
      "address": address.text.trim(),
      "imageUrl": _imageUrl.toString(),
    }).then((value) {
      Navigator.pop(context);
    });
  }
}
