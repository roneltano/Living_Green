import 'package:flutter/material.dart';
import 'package:living_plant/DialogBox/errorDialog.dart';
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/widgets/customTextFieldRegisterPage.dart';

class apiPage extends StatefulWidget {
  const apiPage({super.key});

  @override
  State<apiPage> createState() => _apiPageState();
}

class _apiPageState extends State<apiPage> {
  TextEditingController _updateAPI = TextEditingController();

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() async {
    await LivingPlant.firebaseFirestore!
        .collection("api")
        .doc("HEmMnpsEKMje2B6TUSYU")
        .get()
        .then((result) {
      String api = result.data()!['api'];
      _updateAPI.text = api;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            uploadAPI();
          },
          child: const Text("Change API"),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Update API",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            customTextFieldRegsiterPage(
              textEditingController: _updateAPI,
              icon: const Icon(Icons.api),
              isSecure: false,
              textInputType: TextInputType.text,
              enabledEdit: true,
              hint: "API",
            ),
          ],
        ),
      ),
    );
  }

  uploadAPI() {
    _updateAPI.text.isNotEmpty
        ? updateAPIFunction()
        : showDialog(
            context: context,
            builder: (_) => const errorDialog(message: "API can't be Empty"),
          );
  }

  updateAPIFunction() {
    showDialog(
        context: context,
        builder: (_) => const loadingDialog(message: "Updating API"));
    LivingPlant.firebaseFirestore!
        .collection("api")
        .doc("HEmMnpsEKMje2B6TUSYU")
        .update({
      "api": _updateAPI.text.toString(),
      "Date": DateTime.now(),
    }).then((value) {
      Navigator.pop(context);
    });
  }
}
