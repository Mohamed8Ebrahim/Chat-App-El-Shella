// Import necessary packages and files
// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Views/Show_Profile_View.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';
import 'package:hash_cached_image/hash_cached_image.dart';

// Custom Chat AppBar Widget
class CustomChatAppBar extends StatefulWidget {
  const CustomChatAppBar({super.key, required this.chatUsers});

  final ChatUsers chatUsers;

  @override
  State<CustomChatAppBar> createState() => _CustomChatAppBarState();
}

class _CustomChatAppBarState extends State<CustomChatAppBar> {
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    // Listen to changes in the friend's online status in Firestore
    Apis.firestore
        .collection('users')
        .doc(widget.chatUsers.id)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        isOnline = snapshot.data()?['is_online'] ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ShowProfileView(userData: widget.chatUsers)),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: mq.height * .005),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .2),
              child: HashCachedImage(
                fit: BoxFit.cover,
                width: mq.height * .05,
                height: mq.height * .05,
                imageUrl: widget.chatUsers.image!,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(Icons.error)),
              ),
            ),
            SizedBox(width: mq.width * .02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatUsers.name!,
                  style: const TextStyle(
                    fontSize: 18,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  isOnline
                      ? 'online'
                      : Apis.getLastActiveTime(
                          context: context,
                          lastActive: widget.chatUsers.lastActive ?? ''),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
