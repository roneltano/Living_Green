import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/Authentication/login.dart';
import 'package:provider/provider.dart';

class profileUser extends StatefulWidget {
  const profileUser({super.key});

  @override
  State<profileUser> createState() => _profileUserState();
}

class _profileUserState extends State<profileUser> {
  String imageGetting =
      LivingPlant.sharedPreferences!.getString(LivingPlant.image) ?? '';

  var firstName =
      LivingPlant.sharedPreferences!.getString(LivingPlant.firstName);
  var lastName = LivingPlant.sharedPreferences!.getString(LivingPlant.lastName);
  var address = LivingPlant.sharedPreferences!.getString(LivingPlant.address);

  @override
  Widget build(BuildContext context) {
    var postProvier = Provider.of(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                      "images/Rectangle2.png",
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              showDialogFunctoin();
                            },
                            icon: const Icon(
                              Icons.more_vert_outlined,
                            ),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$firstName $lastName",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 23),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 17,
                              ),
                              Text(
                                address.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // color: Color(0XFF48A2F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "CHATS",
                          style: TextStyle(color: Color(0XFFC5C5C5)),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0XFF48A2F5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "MY PLANTS",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: Colors.amber,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "TRADES",
                        style: TextStyle(color: Color(0XFFC5C5C5)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  showDialogFunctoin() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        scrollable: true,
        content: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                logoutFunction();
              },
              child: const Text("Log out"),
            )
          ],
        ),
      ),
    );
  }

  logoutFunction() async {
    await LivingPlant.firebaseAuth!.signOut();
    Route route = MaterialPageRoute(builder: (_) => const UserLogin());
    Navigator.pushReplacement(context, route);
  }
}
