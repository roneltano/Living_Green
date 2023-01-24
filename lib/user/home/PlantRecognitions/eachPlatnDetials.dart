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
                    // child: Column(
                    //   children: [
                    //     // plantImage.isNotEmpty
                    //     //     ? Image(
                    //     //         image: NetworkImage(
                    //     //           plantImage,
                    //     //         ),
                    //     //       )
                    //     //     : const CircularProgressIndicator(),
                    //     // const SizedBox(
                    //     //   height: 5,
                    //     // ),
                    //     Text(
                    //       model.suggestions![ID].plantName.toString(),
                    //       textAlign: TextAlign.center,
                    //       style: const TextStyle(
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
                // Text(
                //   "${model.suggestions![0].id![IDGetting].probability.toString().substring(2, 4)}%",
                //   style: const TextStyle(color: LivingPlant.primaryColor),
                // ),
              ],
            ),
            // Container(
            //   margin: const EdgeInsets.only(right: 30, left: 30, top: 5),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text("Description"),
            //             const SizedBox(
            //               height: 5,
            //             ),
            //             Text(
            //               model.suggestions![ID].plantDetails!.wikiDescription!
            //                   .value
            //                   .toString(),
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             const Text("Taxonomy"),
            //             const SizedBox(
            //               height: 5,
            //             ),
            //             Row(
            //               children: [
            //                 const Text("Kingdom:"),
            //                 Text(
            //                   model.suggestions![ID].plantDetails!.taxonomy!
            //                       .kingdom
            //                       .toString(),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 const Text("Phylum:"),
            //                 Text(
            //                   model.suggestions![ID].plantDetails!.taxonomy!
            //                       .phylum
            //                       .toString(),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 const Text("Class:"),
            //                 Text(
            //                   model.suggestions![ID].plantDetails!.taxonomy!
            //                       .order
            //                       .toString(),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 Text("Order:"),
            //                 Text(
            //                   model.suggestions![ID].plantDetails!.taxonomy!
            //                       .order
            //                       .toString(),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 Text("Family:"),
            //                 Text(
            //                   model.suggestions![ID].plantDetails!.taxonomy!
            //                       .family
            //                       .toString(),
            //                 ),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 const Text("Genus:"),
            //                 Text(model.suggestions![ID].plantDetails!
            //                     .structuredName!.genus
            //                     .toString()),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }
}
