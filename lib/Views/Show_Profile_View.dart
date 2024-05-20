// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';
import 'package:hash_cached_image/hash_cached_image.dart';

class ShowProfileView extends StatelessWidget {
  const ShowProfileView({super.key, required this.userData});
  final ChatUsers userData;
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 189, 251, 119),
          elevation: 1,
          title: Text(
            userData.name!,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, letterSpacing: 1),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: profileImage(),
                    ),
                    SizedBox(height: mq.height * .02),
                    Text(
                      userData.email!,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Text(
                        'About: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        userData.about!,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ])
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: mq.height * .05),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Joined on: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          Apis.getLastMessageTime(
                              showYear: true,
                              context,
                              userData.lastActive ?? ''),
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  HashCachedImage profileImage() {
    return HashCachedImage(
      fit: BoxFit.cover,
      width: mq.height * .22,
      height: mq.height * .22,
      imageUrl: userData.image!,
      errorWidget: (context, url, error) =>
          const CircleAvatar(child: Icon(Icons.error)),
    );
  }
}
