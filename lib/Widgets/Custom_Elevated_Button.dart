// ignore_for_file: file_names

import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.onPressed});
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        fixedSize: Size(mq.width * .8, mq.height * .06),
        backgroundColor: const Color.fromARGB(255, 189, 251, 119),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/google.png',
            height: mq.height * .03,
          ),
          const SizedBox(width: 8),
          const Text(
            "Sign in with",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const Text(
            " google",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
