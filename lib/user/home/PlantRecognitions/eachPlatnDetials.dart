import 'dart:math' as mm;

import 'package:flutter/material.dart';
import 'package:living_plant/providers/imageRecogntionProvider.dart';
import 'package:provider/provider.dart';
import 'package:living_plant/user/home/PlantRecognitions/module/plantModule.dart'
    as module;

class eachPlatnDetials extends StatelessWidget {
  final ID;
  const eachPlatnDetials({super.key, this.ID});

  @override
  Widget build(BuildContext context) {
    int? IDGetting = ID;
    var gettingDataFromPriovider =
        Provider.of<imageRecogntionProvider>(context, listen: true);

    module.Welcome model =
        module.welcomeFromJson(gettingDataFromPriovider.gettingResponseData);

    // var plantImage =
    //     model.suggestions![0].id![234234].url.toString();

    print(model.id);

    String getFirstWords(String sentence, int wordCounts) {
      return sentence.split(" ").sublist(0, wordCounts).join(" ");
    }

    var adsf = gettingDataFromPriovider.gettingResponseData;
    for (var element in model.suggestions!) {
      var ggg = model.suggestions![0].id;

      print("This is the ID GETTING ${ggg}");
      print("This is the ID elemnt ${element.id}");
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0XFFD9D9D9),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Text("");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
