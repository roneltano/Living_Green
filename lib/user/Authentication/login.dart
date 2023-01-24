import 'package:flutter/material.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/admin/home/adminHomePage.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/register.dart';
import 'package:living_plant/user/Authentication/resetPassword.dart';
import 'package:living_plant/user/home/bottomAndUp.dart';
import 'package:living_plant/widgets/customTextField.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLogin();
}

class _UserLogin extends State<UserLogin> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool hidden = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/logo.png",
                    width: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: LivingPlant.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                  Form(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        key: _key,
                        children: [
                          customTextField(
                            textEditingController: _email,
                            widget: const Icon(Icons.email),
                            isSecure: false,
                            textInputType: TextInputType.emailAddress,
                            enabledEdit: true,
                            hint: "Email",
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          customTextField(
                            textEditingController: _password,
                            widget: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hidden = !hidden;
                                  print(hidden);
                                });
                              },
                              child: Icon(
                                hidden == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            isSecure: hidden,
                            textInputType: TextInputType.emailAddress,
                            enabledEdit: true,
                            hint: "Password",
                          ),
                          TextButton(
                            onPressed: () {
                              forgetPassword();
                            },
                            child: const Text(
                              "Forget Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      loginIn();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 30, left: 30),
                      decoration: BoxDecoration(
                        color: LivingPlant.primaryColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        "Login In",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have an account ?"),
                      TextButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (_) => const UserRegister());
                          Navigator.push(context, route);
                        },
                        child: const Text("Sign up"),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  forgetPassword() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => resetPassword()));
  }

  loginIn() {
    _email.text.isNotEmpty && _password.text.isNotEmpty
        ? signIn()
        : showDialog(
            context: context,
            builder: (_) => const errorDialog(
              message: "Please Fill up the form",
            ),
          );
  }

  signIn() async {
    showDialog(
        context: context,
        builder: (_) => loadingDialog(message: "Authenticating"));
    await LivingPlant.firebaseAuth!
        .signInWithEmailAndPassword(
            email: _email.text.trim(), password: _password.text.trim())
        .then(
      (auth) {
        print(auth.user);
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

  getDataFromFirebase(String userAuth) async {
    await LivingPlant.firebaseFirestore!
        .collection("users")
        .doc(userAuth)
        .get()
        .then((result) {
      if (result.data()!.isNotEmpty) {
        String userTypeResult = result.data()!['userType'];
        switch (userTypeResult) {
          case "admin":
            LivingPlant.sharedPreferences!.setString(
                LivingPlant.adminFirstName, result.data()!['firstName']);

            LivingPlant.sharedPreferences!.setString(
                LivingPlant.adminSecondName, result.data()!['lastName']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.adminAddress, result.data()!['address']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.adminEmail, result.data()!['email']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.adminImage, result.data()!['imageUrl']);

            LivingPlant.sharedPreferences!.setInt(
                LivingPlant.adminMobileNum.toString(),
                result.data()!['mobileNumber']);
            Route route = MaterialPageRoute(builder: (_) => adminHomePage());
            Navigator.pushReplacement(context, route);
            break;
          case "expert":
            // LivingPlant.sharedPreferences!.setString(
            //     LivingPlant.expertFirstName, result.data()!['firstName']);

            // LivingPlant.sharedPreferences!.setString(
            //     LivingPlant.expertSecondName, result.data()!['lastName']);

            // LivingPlant.sharedPreferences!.setString(
            //     LivingPlant.expertAddress, result.data()!['address']);

            // LivingPlant.sharedPreferences!
            //     .setString(LivingPlant.expertEmail, result.data()!['email']);

            // LivingPlant.sharedPreferences!
            //     .setString(LivingPlant.expertImage, result.data()!['imageUrl']);

            // LivingPlant.sharedPreferences!.setInt(
            //     LivingPlant.expertMobileNum.toString(),
            //     result.data()!['mobileNumber']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.firstName, result.data()!['firstName']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.lastName, result.data()!['lastName']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.address, result.data()!['address']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.email, result.data()!['email']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.image, result.data()!['imageUrl']);

            LivingPlant.sharedPreferences!.setString(
                LivingPlant.expertMark.toString(), result.data()!['userType']);

            LivingPlant.sharedPreferences!.setInt(
              LivingPlant.mobileNum.toString(),
              result.data()!['mobileNumber'],
            );

            Route route = MaterialPageRoute(builder: (_) => bottomAndUp());
            Navigator.pushReplacement(context, route);
            break;

          case "user":
            LivingPlant.sharedPreferences!
                .setString(LivingPlant.firstName, result.data()!['firstName']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.lastName, result.data()!['lastName']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.address, result.data()!['address']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.email, result.data()!['email']);

            LivingPlant.sharedPreferences!
                .setString(LivingPlant.image, result.data()!['imageUrl']);

            LivingPlant.sharedPreferences!.setString(
                LivingPlant.expertMark.toString(), result.data()!['userType']);

            LivingPlant.sharedPreferences!.setInt(
              LivingPlant.mobileNum.toString(),
              result.data()!['mobileNumber'],
            );

            Route route = MaterialPageRoute(builder: (_) => bottomAndUp());
            Navigator.pushReplacement(context, route);
            break;
        }
      } else {
        showDialog(
          context: context,
          builder: (_) => const errorDialog(message: "Error Happend"),
        );
      }
      // Navigator.pop(context);
      // Route route = MaterialPageRoute(builder: (_) => homePage());
      // Navigator.pushReplacement(context, route);
    });
  }
}
