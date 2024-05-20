// ignore_for_file: file_names

import 'dart:developer';
import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/API/SignIn_With_Google.dart';
import 'package:el_shela/Helper/Fade_Animation.dart';
import 'package:el_shela/Helper/Show_Dialog.dart';
import 'package:el_shela/Views/Home_View.dart';
import 'package:el_shela/Widgets/Custom_Elevated_Button.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isAnimated = false;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
    super.initState();
  }

  _handleGoogleBtnClick() {
    ShowDialog().showProgressBar(context);
    SigninWithGoogle().signInWithGoogle(context).then((user) async {
      Navigator.pop(context);
      if (user != null) {
        log("\nuser:${user.user}");
        log("\nuserAdditionalInfo:${user.additionalUserInfo}");
        if (await Apis.userExists()) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeView(),
            ),
          );
        } else {
          Apis.createNewUser().then(
            (value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeView(),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 189, 251, 119),
        elevation: 1,
        toolbarHeight: mq.height * .08,
        title: const Text(
          'Welcom To El Shela',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimated ? mq.width * .13 : mq.width * -.6,
            duration: const Duration(milliseconds: 1000),
            child: Image.asset('assets/images/social-media.png',
                height: mq.height * .35),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .1,
            child: FadeAnimation(
              delay: 1,
              child: CustomElevatedButton(
                onPressed: () {
                  _handleGoogleBtnClick();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
