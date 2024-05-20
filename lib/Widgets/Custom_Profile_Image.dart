// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Widgets/Profile_Image_Button.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';
import 'package:hash_cached_image/hash_cached_image.dart';
import 'package:image_picker/image_picker.dart';

class CustomProfileImage extends StatefulWidget {
  const CustomProfileImage({
    super.key,
    required this.user,
  });

  final ChatUsers user;

  @override
  State<CustomProfileImage> createState() => _CustomProfileImageState();
}

class _CustomProfileImageState extends State<CustomProfileImage> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: Image.file(
                  File(_image!),
                  fit: BoxFit.cover,
                  width: mq.height * .25,
                  height: mq.height * .25,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: HashCachedImage(
                  fit: BoxFit.cover,
                  width: mq.height * .22,
                  height: mq.height * .22,
                  imageUrl: widget.user.image!,
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.error)),
                ),
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: MaterialButton(
            elevation: 1,
            color: Colors.white,
            onPressed: () {
              _showBottomSheet(context);
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.edit, color: Colors.blue),
          ),
        )
      ],
    );
  }

  _showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: mq.height * .02),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Picture Profile Pictur',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileImageButton(
                    imagePath: 'assets/images/add.png',
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                          Apis.updateProfilePicture(File(_image!));
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                  ProfileImageButton(
                    imagePath: 'assets/images/camera.png',
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('Image Path: ${image.path}');
                        setState(() {
                          _image = image.path;
                          Apis.updateProfilePicture(File(_image!));
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
