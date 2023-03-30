import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/widgets/customTextField.dart';

class resetPassword extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        title: const Text("Reset Password"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "images/logo.png",
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Reset Password",
                      style: TextStyle(
                          color: LivingPlant.primaryColor,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          customTextField(
                            textEditingController: _emailTextEditingController,
                            textInputType: TextInputType.emailAddress,
                            isSecure: false,
                            enabledEdit: true,
                            widget: null,
                            icon: const Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            hint: "Email",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfEmailIsEmpty(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: LivingPlant.primaryColor),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Reset",
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
            ),
          ),
        ],
      ),
    );
  }

  checkIfEmailIsEmpty(BuildContext context) {
    _emailTextEditingController.text.isNotEmpty
        ? resetPasswordFun(context)
        : showDialog(
            context: context,
            builder: (_) => const errorDialog(message: "Please input Email"),
          );
  }

  resetPasswordFun(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const loadingDialog(
        message: "Resetting Password",
      ),
    );
    resetingPassword(context);
  }

  resetingPassword(context) {
    LivingPlant.firebaseAuth!
        .sendPasswordResetEmail(email: _emailTextEditingController.text.trim())
        .then(
      (value) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const errorDialog(message: "Email were sent"),
        );
      },
    ).catchError(
      (error) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => const errorDialog(
              message: "Please make sure the email is correct"),
        );
      },
    );
  }
}
