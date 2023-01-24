import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dateFixing;
import 'package:living_plant/DialogBox/loadingDialog.dart';
import 'package:living_plant/config/config.dart';

class CheckExpertStatusPage extends StatefulWidget {
  const CheckExpertStatusPage({super.key});

  @override
  State<CheckExpertStatusPage> createState() => _CheckExpertStatusPage();
}

// This Page will show The User Donations
class _CheckExpertStatusPage extends State<CheckExpertStatusPage> {
  User? user = LivingPlant.firebaseAuth!.currentUser;
  @override
  Widget build(BuildContext context) {
    String currentUser = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Certificate Status"),
        centerTitle: true,
      ),
      body: displayTimeSlot(context),
    );
  }

  // Date
  displayTimeSlot(BuildContext context) {
    // var module = Provider.of<donateBloodModule>(context);
    return Column(
      children: [
        Container(
          color: LivingPlant.primaryColor,
          child: Row(
            children: [],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: LivingPlant.firebaseFirestore!
                .collection("users")
                .where("userType", isEqualTo: "expert")
                .orderBy("dateReport", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        String userStatus = snapshot
                            .data!.docs[index]['accountStatus']
                            .toString();
                        String imageGetting =
                            snapshot.data!.docs[index]['imageUrl'];
                        return Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 206, 205, 205),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              imageGetting.length > 5
                                  ? CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      backgroundImage:
                                          NetworkImage(imageGetting),
                                      radius: 50,
                                    )
                                  : const CircleAvatar(
                                      backgroundColor: Colors.black12,
                                      radius: 50,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Name: "),
                                      Text(
                                        "${snapshot.data!.docs[index]['firstName']}",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Email: ',
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]['email']
                                            .toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Address: ',
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['address']
                                        .toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Proof Status: ',
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['proofeStatus']
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Mobile Number: ',
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['mobileNumber']
                                        .toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Account Status: ',
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['accountStatus']
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: userStatus == "active"
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Mobile Number: ',
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['mobileNumber']
                                        .toString(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'User Created on : ',
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['dateReport']
                                        .toString(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        acceptCertficate(
                                            snapshot.data!.docs[index].id);
                                      },
                                      child: const Text("Accept Proof"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        rejectCertficate(
                                            snapshot.data!.docs[index].id);
                                      },
                                      child: const Text("Reject Proof"),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showImage(snapshot.data!.docs[index]
                                            ['proof']);
                                      },
                                      child: const Text("Display"),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // downloadImage(
                                        //     snapshot.data!.docs[index]
                                        //         ['proveOfDonation']);
                                      },
                                      child: const Text("Download"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }

  showImage(image) {
    return showDialog(
      context: context,
      builder: (contextd) => AlertDialog(
        content: Container(
          child: Image.network(image),
        ),
      ),
    );
  }

// accept functoin
  acceptCertficate(String certificateID) async {
    showDialog(
      context: context,
      builder: (_) => loadingDialog(message: "Accepting Certificate"),
    );
    await LivingPlant.firebaseFirestore!
        .collection("users")
        .doc(certificateID)
        .update({
      "proofeStatus": "Accepted",
    });
    Navigator.pop(context);
  }

  // accept functoin
  rejectCertficate(String certificateID) async {
    showDialog(
      context: context,
      builder: (_) => loadingDialog(message: "Rejecting Certificate"),
    );
    await LivingPlant.firebaseFirestore!
        .collection("users")
        .doc(certificateID)
        .update({
      "proofeStatus": "Rejected",
    });
    Navigator.pop(context);
  }
}
