import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' as dateFixing;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:living_plant/user/home/bottomAndUp.dart';
import 'package:living_plant/widgets/customTextFieldRegisterPage.dart';

class BotanistRegister extends StatefulWidget {
  const BotanistRegister({super.key});

  @override
  State<BotanistRegister> createState() => _BotanistRegister();
}

class _BotanistRegister extends State<BotanistRegister> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _fristName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? imageXFile;
  String? imageUrl;

  XFile? imageXFileProofe;
  String? imageUrlProofe;

  Position? position;
  List<Placemark>? placemark;

  bool hidden1 = true;
  bool hidden2 = true;

  // Picking Image from Gellery
  Future gelleryImagePicking() async {
    imageXFile = (await _imagePicker.pickImage(source: ImageSource.gallery))!;
    setState(() {
      imageXFile;
    });
  }

  // Picking Image from Gellery
  Future expterImagePicking() async {
    imageXFileProofe =
        (await _imagePicker.pickImage(source: ImageSource.gallery))!;
    setState(() {
      imageXFileProofe;
    });
  }

  showingDialogChecking() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const loadingDialog(
              message: "Please Wait, Getting your location",
            )).then((value) {});
  }

  // For location
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
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
      _address.text = complateAddress;
      Navigator.pop(context);
      return _address.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Plant Expert/\nBotainst",
          textAlign: TextAlign.center,
        ),
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0XFF2C965B),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/expert.png",
                width: 300,
              ),
              Form(
                child: Container(
                  margin: const EdgeInsets.only(right: 40, left: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        key: _key,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                gelleryImagePicking();
                              },
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        const Color.fromARGB(15, 178, 17, 17),
                                    backgroundImage: imageXFile != null
                                        ? FileImage(File(imageXFile!.path))
                                        : null,
                                    child: imageXFile == null
                                        ? Icon(
                                            Icons.add_photo_alternate,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            color: Colors.white,
                                          )
                                        : null),
                              ),
                            ),
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _fristName,
                            widget: const Icon(Icons.person),
                            isSecure: false,
                            textInputType: TextInputType.name,
                            enabledEdit: true,
                            hint: "First Name",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _lastName,
                            widget: const Icon(Icons.person),
                            isSecure: false,
                            textInputType: TextInputType.name,
                            enabledEdit: true,
                            hint: "Last Name",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _address,
                            widget: const Icon(Icons.location_on),
                            isSecure: false,
                            textInputType: TextInputType.emailAddress,
                            enabledEdit: true,
                            hint: "Address",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _mobileNumber,
                            widget: const Icon(Icons.phone),
                            isSecure: false,
                            textInputType: TextInputType.phone,
                            enabledEdit: true,
                            hint: "Mobile Number",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _email,
                            widget: const Icon(Icons.email),
                            isSecure: false,
                            textInputType: TextInputType.emailAddress,
                            enabledEdit: true,
                            hint: "Email",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _password,
                            widget: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidden1 = !hidden1;
                                });
                              },
                              child: Icon(
                                hidden1 == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            isSecure: hidden1,
                            textInputType: TextInputType.text,
                            enabledEdit: true,
                            hint: "Password",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          customTextFieldRegsiterPage(
                            textEditingController: _cPassword,
                            widget: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidden2 = !hidden2;
                                });
                              },
                              child: Icon(
                                hidden2 == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            isSecure: hidden2,
                            textInputType: TextInputType.text,
                            enabledEdit: true,
                            hint: "Confirm Password",
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.grey)),
                                onPressed: () {
                                  _determinePosition();
                                },
                                icon: const Icon(Icons.map_rounded),
                                label: const Text("Get Location")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, right: 45, left: 45),
                child: Column(
                  children: [
                    const Text(
                      "Upload a proof or any certification\nthat you are a expert in these field",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        expterImagePicking();
                      },
                      child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        decoration: imageXFileProofe == null
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(255, 255, 255, 1),
                              )
                            : BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                    File(imageXFileProofe!.path),
                                  ),
                                ),
                              ),
                        child: const Icon(
                          Icons.upload,
                          color: LivingPlant.primaryColor,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  register();
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, right: 50, left: 50),
                  decoration: BoxDecoration(
                    color: LivingPlant.buttonColorBlue,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text(
                    "Become an Expert",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  forgetPassword() {
    showDialog(
      context: context,
      builder: (_) => const loadingDialog(message: "Checking Message"),
    );
  }

  register() {
    _password.text == _cPassword.text
        ? _lastName.text.isNotEmpty &&
                _fristName.text.isNotEmpty &&
                _address.text.isNotEmpty &&
                _mobileNumber.text.isNotEmpty &&
                _email.text.isNotEmpty &&
                _password.text.isNotEmpty &&
                _cPassword.text.isNotEmpty
            ? dialogSavingData("Saving Data...")
            : showDialog(
                context: context,
                builder: (_) => const errorDialog(
                  message: "Please Fill up the form",
                ),
              )
        : showDialog(
            context: context,
            builder: (_) => const errorDialog(
              message: "Password Don't Match",
            ),
          );
  }

  dialogSavingData(String mesg) async {
    showDialog(
      context: context,
      builder: (_) => loadingDialog(
        message: mesg,
      ),
    );
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();

    if (imageXFile != null) {
      Reference reference = LivingPlant.firebaseStorage!
          .ref()
          .child("usseImages")
          .child("usersProfiles_${imageName}");
      UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((imageUrll) {
        imageUrl = imageUrll;
      });
    }
    if (imageXFileProofe != null) {
      Reference reference = LivingPlant.firebaseStorage!
          .ref()
          .child("proofe")
          .child("proofe_${imageName}");
      UploadTask uploadTask = reference.putFile(File(imageXFileProofe!.path));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((imageUrllProofe) {
        imageUrlProofe = imageUrllProofe;
      });
    }
    registerFunction();
  }

  registerFunction() async {
    await LivingPlant.firebaseAuth!
        .createUserWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim())
        .then(
      (auth) {
        String authCre = auth.user!.uid;
        getDataFromFirebase(authCre);
      },
    ).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => errorDialog(message: error),
        );
      },
    );
  }

  getDataFromFirebase(String userAuth) {
    LivingPlant.firebaseFirestore!.collection("users").doc(userAuth).set({
      "firstName": _fristName.text.trim(),
      "lastName": _lastName.text.trim(),
      "address": _address.text.trim(),
      "mobileNumber": int.parse(_mobileNumber.text.trim()),
      "email": _email.text.trim(),
      "imageUrl": imageUrl!.trim(),
      "accountStatus": "active",
      "UserUid": userAuth,
      "dateReport":
          dateFixing.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      "userCreated": DateTime.now(),
      "userType": "expert",
      "proof": imageUrlProofe,
      "proofeStatus": "Pending",
    }).then((value) {
      Route route = MaterialPageRoute(builder: (_) => const UserLogin());
      Navigator.pushReplacement(context, route);
    });
  }
}
