// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:referral_app/enums/state.dart';
import 'package:referral_app/provider/ref_provider.dart';
import 'package:referral_app/screens/authentication/login.dart';
import 'package:referral_app/screens/home_page.dart';
import 'package:referral_app/utils/message.dart';

class RefCodePage extends StatefulWidget {
  @override
  _RefCodePageState createState() => _RefCodePageState();
}

class _RefCodePageState extends State<RefCodePage> {
  final TextEditingController _refController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<RefProvider>(builder: (context, model, child) {
      return model.state == ViewState.Busy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.blue),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Enter referral code",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(30.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  CustomTextField(
                                    _refController,
                                    hint: 'Referal code',
                                    password: false,
                                    border: Border.all(color: Colors.blue),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  //Validate User Inputs
                                  if (_refController.text.isEmpty) {
                                    showMessage(
                                        context, "All field are required");
                                  } else {
                                    await model.setReferral(
                                        _refController.text.trim());

                                    if (model.state == ViewState.Success) {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                          (route) => false);
                                    } else {
                                      showMessage(context, model.message);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Continue",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  //Navigate to Register Page

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false);
                                },
                                child: Text(
                                  "No referral? continue instead",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            );
    }));
  }
}
