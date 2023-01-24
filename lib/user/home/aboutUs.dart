import 'package:flutter/material.dart';
import 'package:living_plant/config/config.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
              height: 50,
            ),
            Text(
              "Welcome To Living Green!",
              style: TextStyle(
                  color: LivingPlant.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Text(
                "Living Green aims to expound botanical research through a Mobile Botanical Identifier mobile application for finding the uploaded photo of an unknown plant with a barter system. It is a mobile application that connects users with plant enthusiasts and plant experts to aid in identifying a plant/s name. Here we will provide you only interesting content, which you will like very much. We're dedicated to providing you the best of Educational, with a focus on dependability and Plant Recognition. We're working to turn our passion for Educational into a booming mobile application. We hope you enjoy as much as we enjoy offering them to you.",
              ),
            ),
            Text("Please give your support and love"),
            SizedBox(
              height: 10,
            ),
            Text("Thanks For Visiting Our Application"),
            SizedBox(
              height: 10,
            ),
            Text("Have a nice day!"),
          ],
        ),
      ),
    );
  }
}
