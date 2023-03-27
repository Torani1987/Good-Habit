import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todolist_firebase/pages/phone_auth.dart';

import '../pages/home_page.dart';

class AuthService {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar = SnackBar(content: Text('Not Able To Sign In'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: 'token');
    } catch (e) {}
  }

  Future<void> phoneVerify(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackbar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) async {
      showSnackbar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int? forceResendingtoken]) {
      showSnackbar(context, "Verification code sent on the phone number");
      setData(verificationID);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackbar(context, "Timed Out");
    };
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential usercredential =
          await auth.signInWithCredential(credential);
      storeTokenAndData(usercredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
      showSnackbar(context, "Logged In");
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void showSnackbar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Future deletedDoc(String id) async {
    await FirebaseFirestore.instance.collection("TaskList").doc(id).delete();
  }
}
