// ignore_for_file: file_names

import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';

class ElevatedButtonIcon extends StatelessWidget {
  const ElevatedButtonIcon({
    super.key,
    required this.onPressed,
  });
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        elevation: 5,
        minimumSize: Size(mq.width * .5, mq.height * .06),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
      label: const Text(
        'Update',
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
