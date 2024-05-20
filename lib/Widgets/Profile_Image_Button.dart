// ignore_for_file: file_names

import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';

class ProfileImageButton extends StatelessWidget {
  const ProfileImageButton(
      {super.key, required this.imagePath, this.onPressed});
  final String imagePath;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        fixedSize: Size(mq.width * .3, mq.height * .15),
      ),
      onPressed: onPressed,
      child: Image.asset(imagePath, height: 50),
    );
  }
}
