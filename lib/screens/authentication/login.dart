// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:referral_app/enums/state.dart';
import 'package:referral_app/provider/auth_provider.dart';
import 'package:referral_app/screens/authentication/registration.dart';
import 'package:referral_app/screens/home_page.dart';
import 'package:referral_app/utils/message.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(builder: (context, model, child) {
        return model.state == ViewState.Busy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.purple),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Continue to your account",
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
                                      _emailController,
                                      hint: 'Email',
                                      password: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextField(
                                      _passwordController,
                                      hint: 'Password',
                                      obscure: true,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    print(_emailController.text);
                                    print(_passwordController.text);
                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      showMessage(
                                          context, "All field are required");
                                    } else {
                                      await model.loginUser(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim());

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
                                    //Validate User Inputs
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Navigate to Register Page
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                RegisterPage()));
                                  },
                                  child: Text(
                                    "Want to join?",
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
      }),
    );
  }
}
