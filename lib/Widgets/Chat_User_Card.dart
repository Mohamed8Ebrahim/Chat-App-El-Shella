// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/Message_Model.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Views/Chat_View.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key, required this.user});

  final ChatUsers user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  late final String conversationId;
  bool isOnline = false;
  Message? latestMessage;

  @override
  void initState() {
    super.initState();
    conversationId = Apis.generateConversationId(
      Apis.user?.uid,
      widget.user.id,
    );

    // Listen to changes in the friend's online status in Firestore
    Apis.firestore
        .collection('users')
        .doc(widget.user.id) // Use the friend's user ID
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatView(
              chatUsers: widget.user,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(widget.user.image ?? ''),
          ),
          title: Text(
            widget.user.name ?? '',
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: StreamBuilder<List<Message>>(
            stream:
                Apis.getMessagesStream(conversationId, widget.user.id ?? ''),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                latestMessage = snapshot.data!.last;
                return Text(
                  latestMessage!.msg ?? '',
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                );
              } else {
                // If no messages are available, display user's about text
                return Text(
                  widget.user.about ?? '',
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                );
              }
            },
          ),
          trailing: _buildOnlineIndicator(),
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    // Check if the friend is online and return the appropriate widget
    if (isOnline) {
      return Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      return Text(
        Apis.getLastMessageTime(context, widget.user.lastActive ?? ''),
        style: const TextStyle(color: Colors.black54),
      );
    }
  }
}
