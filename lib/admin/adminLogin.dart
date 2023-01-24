import 'package:flutter/material.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/register.dart';
import 'package:living_plant/user/home/bottomAndUp.dart';
import 'package:living_plant/widgets/customTextField.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLogin();
}

class _AdminLogin extends State<AdminLogin> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
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
                "Admin",
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
                      icon: const Icon(Icons.email),
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
                      icon: const Icon(Icons.lock),
                      isSecure: false,
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
                    Route route =
                        MaterialPageRoute(builder: (_) => const UserRegister());
                    Navigator.push(context, route);
                  },
                  child: const Text("Sign up"),
                )
              ],
            ),
          ],
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
    LivingPlant.firebaseAuth!
        .signInWithEmailAndPassword(
            email: _email.text, password: _password.text)
        .then(
      (auth) {
        print(auth.user);
        String authCre = auth.user.toString();
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
    LivingPlant.firebaseFirestore!
        .collection("users")
        .doc(userAuth)
        .get()
        .then((result) {
      Navigator.pop(context);
      Route route = MaterialPageRoute(builder: (_) => bottomAndUp());
      Navigator.pushReplacement(context, route);
    });
  }
}
