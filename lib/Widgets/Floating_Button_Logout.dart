// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Helper/Show_Dialog.dart';
import 'package:el_shela/Views/Login_View.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FloatingButtonLogout extends StatelessWidget {
  const FloatingButtonLogout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.redAccent,
      onPressed: () async {
        await Apis.updateActiveStatus(false);
        // ignore: use_build_context_synchronously
        ShowDialog().showProgressBar(context);
        await Apis.auth.signOut().then((value) async {
          await GoogleSignIn().signOut().then((value) {
            //for hiding progressBar
            Navigator.pop(context);
            //for removing HomeView
            Navigator.pop(context);
            Apis.auth = FirebaseAuth.instance;
            //for replacing HomeView with LoginView
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return const LoginView();
                },
              ),
            );
          });
        });
      },
      label: const Text('Logout', style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.logout, color: Colors.white),
    );
  }
}
