// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Views/Profile_View.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';

class CustomProfilTextFields extends StatelessWidget {
  const CustomProfilTextFields({
    super.key,
    required this.widget,
  });

  final ProfileView widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: widget.userData.name,
          onSaved: (val) => Apis.me.name = val ?? '',
          validator: (value) {
            if (value!.isEmpty) {
              return "Required Field";
            } else if (value.trim().isEmpty) {
              // Check if input contains only spaces after trimming
              return "This field can't be empty";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person, color: Colors.blue),
            hintText: 'Enter your name',
            label: const Text('Name'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: mq.height * .01),
        TextFormField(
          initialValue: widget.userData.about,
          onSaved: (val) => Apis.me.about = val ?? '',
          validator: (value) {
            if (value!.isEmpty) {
              return "Required Field";
            } else if (value.trim().isEmpty) {
              // Check if input contains only spaces after trimming
              return "This field can't be empty";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.info_outline, color: Colors.blue),
            hintText: 'eg. Feeling Happy',
            label: const Text('about'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
