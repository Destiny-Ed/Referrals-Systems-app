import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:referral_app/enums/state.dart';

class AuthProvider extends ChangeNotifier {
  ViewState state = ViewState.Idle;

  String message = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference profileRef =
      FirebaseFirestore.instance.collection("users");

  loginUser(String? email, String? password) async {
    state = ViewState.Busy;
    notifyListeners();

    try {
      await auth.signInWithEmailAndPassword(email: email!, password: password!);
      message = "Login success";
      state = ViewState.Success;
      notifyListeners();
    } on FirebaseException catch (e) {
      message = e.message.toString();
      state = ViewState.Error;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      state = ViewState.Error;
      notifyListeners();
    }
  }

  registerUser(String? email, String? password) async {
    state = ViewState.Busy;
    notifyListeners();

    try {
      await auth.createUserWithEmailAndPassword(
          email: email!, password: password!);

      ///Create user profile
      createUserProfile();
      message = "Register success";
      state = ViewState.Success;
      notifyListeners();
    } on FirebaseException catch (e) {
      message = e.message.toString();
      state = ViewState.Error;
      notifyListeners();
    } catch (e) {
      message = e.toString();
      state = ViewState.Error;
      notifyListeners();
    }
  }

  void createUserProfile() async {
    final body = {
      "refCode": auth.currentUser!.uid,
      "email": auth.currentUser!.email,
      "date_created": DateTime.now(),
      "referals": <String>[],
      "refEarnings": 0
    };

    await Future.delayed(const Duration(seconds: 3));

    profileRef.add(body);
  }
}
