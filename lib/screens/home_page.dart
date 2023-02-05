import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:referral_app/screens/authentication/login.dart';
import 'package:referral_app/utils/message.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: profileRef
              .where("refCode", isEqualTo: auth.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!.docs[0];
            final earnings = data.get("refEarnings");
            List referalsList = data.get('referals');

            final refCode = data.get("refCode");

            return Container(
              padding: const EdgeInsets.all(10),
              child: RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return Future.delayed(const Duration(seconds: 3));
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              title: const Text("Earnings"),
                              subtitle: Text("NGN $earnings"),
                            ),
                          ),
                          const Divider(
                            thickness: 3,
                          ),
                          Card(
                            child: ListTile(
                              title: const Text("Referal Code"),
                              subtitle: Text(refCode),
                              trailing: IconButton(
                                  onPressed: () {
                                    ClipboardData data =
                                        ClipboardData(text: refCode);

                                    Clipboard.setData(data);

                                    showMessage(context, "Ref code copied");
                                  },
                                  icon: const Icon(Icons.copy)),
                            ),
                          ),
                          const Divider(
                            thickness: 3,
                          ),
                          Card(
                              child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Invite your friends to our app and earn NGN 500 when they register with your referal code",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                child: TextButton(
                                    onPressed: () {
                                      String shareLink =
                                          "Hey! use this app to do stuffs and earn NGN 500 after using my ref code ($refCode) ";

                                      Share.share(shareLink);
                                    },
                                    child: const Text("Share link")),
                              )
                            ],
                          )),
                          const Divider(
                            thickness: 3,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Referals"),
                                Text("${referalsList.length}"),
                              ],
                            ),
                          ),
                          if (referalsList.isEmpty) const Text("No referrals"),
                          ...List.generate(referalsList.length, (index) {
                            final data = referalsList[index];
                            return Container(
                              height: 50,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text("${index + 1}"),
                                ),
                                title: Text(data),
                              ),
                            );
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
