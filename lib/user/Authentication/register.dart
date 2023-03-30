import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/Botanist/Authentication/register.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:intl/intl.dart' as dateFixing;
import 'package:living_plant/widgets/customTextFieldRegisterPage.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegister();
}

class _UserRegister extends State<UserRegister> {
  final GlobalKey<FormState> _key = GlobalKey();

  final TextEditingController _fristName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();
  bool hidden1 = true;
  bool hidden2 = true;

  XFile? imageXFile;
  String? imageUrl = 'null';

  File? image;
  final ImagePicker _imagePicker = ImagePicker();

  Position? position;
  List<Placemark>? placemark;

  // Picking Image from Gellery
  Future gelleryImagePicking() async {
    imageXFile = (await _imagePicker.pickImage(source: ImageSource.gallery))!;
    image = File(imageXFile!.path);
    setState(() {
      imageXFile;
    });
  }

  showingDialogChecking() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const loadingDialog(
              message: "Please Wait, we're getting your location",
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Image.asset("images/button.png"),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/pic-2.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Create Your new account",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Form(
                  child: Container(
                    margin: const EdgeInsets.only(right: 15, left: 15),
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
                                          const Color.fromARGB(15, 0, 0, 0),
                                      backgroundImage: imageXFile != null
                                          ? FileImage(File(imageXFile!.path))
                                          : null,
                                      child: imageXFile == null
                                          ? Icon(
                                              Icons.add_photo_alternate,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.20,
                                              color: Colors.grey,
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
                              textEditingController: _address,
                              widget: const Icon(Icons.location_on),
                              isSecure: false,
                              textInputType: TextInputType.text,
                              enabledEdit: true,
                              hint: "Address",
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
                            const SizedBox(
                              height: 5,
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
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    register();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Register"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "You have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Route route =
                            MaterialPageRoute(builder: (_) => UserLogin());
                        Navigator.pushReplacement(context, route);
                      },
                      child: const Text("Log In"),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (_) => const BotanistRegister());
                    Navigator.push(context, route);
                  },
                  child: const Text(
                    "Become a Plant Expert/Botanist?",
                    style: TextStyle(
                        color: LivingPlant.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
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
              message: "Password do not match",
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

    if (imageXFile != null) {
      String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference reference = LivingPlant.firebaseStorage!
          .ref()
          .child("usseImages")
          .child(imageName);
      UploadTask uploadTask = reference.putFile(image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((imageUrll) {
        imageUrl = imageUrll;
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
          builder: (_) => errorDialog(message: error.toString()),
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
      "imageUrl": imageUrl ?? 'f',
      "UserUid": userAuth,
      "dateReport":
          dateFixing.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
      "userCreated": DateTime.now(),
      "accountStatus": "active",
      "userType": "user",
    }).then((value) {
      Route route = MaterialPageRoute(builder: (_) => const UserLogin());
      Navigator.pushReplacement(context, route);
    });
  }
}
