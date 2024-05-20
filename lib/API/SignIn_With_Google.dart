// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Helper/Show_Dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninWithGoogle {
  Future<UserCredential?> signInWithGoogle(context) async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      log('signInWithGoogle: $e');
      ShowDialog()
          .showDialogMes("Something went wrong (Check Internet!)", context);
      return null;
    }
  }
}
