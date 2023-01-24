import 'package:flutter/material.dart';
import 'package:living_plant/admin/home/allUsers.dart';
import 'package:living_plant/admin/home/checkExpertStatusPage.dart';
import 'package:living_plant/admin/home/reportedPosts.dart';
import 'package:living_plant/config/config.dart';
import 'package:living_plant/user/home/aboutUs.dart';
import 'package:living_plant/widgets/drawer.dart';

class adminHomePage extends StatefulWidget {
  @override
  _adminHomePage createState() => _adminHomePage();
}

class _adminHomePage extends State<adminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: adminDrawer(),
      appBar: AppBar(
        flexibleSpace: Container(),
        title: const Text(
          "Living Plant",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      // drawer: myDrawer(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30.0),
          child: GridView.count(
            padding: const EdgeInsets.all(15),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            primary: false,
            crossAxisCount: 2,
            children: [
              GestureDetector(
                onTap: () => {
                  checkExpertStatus(),
                },
                child: Card(
                  color: LivingPlant.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 33,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Experts\n Requests",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => allUsers()))
                },
                child: Card(
                  color: LivingPlant.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 33,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "All\n Users",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const AboutUs()))
                },
                child: Card(
                  color: LivingPlant.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 33,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReportedPosts()))
                },
                child: Card(
                  color: LivingPlant.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.not_interested_sharp,
                        color: Colors.white,
                        size: 33,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Reported Posts",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkExpertStatus() {
    Navigator.of(context);
    Route route =
        MaterialPageRoute(builder: (c) => const CheckExpertStatusPage());
    Navigator.push(context, route);
  }
}
