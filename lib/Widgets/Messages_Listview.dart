// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/Message_Model.dart';
import 'package:el_shela/Widgets/Chat_Message.dart';
import 'package:flutter/material.dart';

class MessagesListView extends StatefulWidget {
  final String conversationId;
  final String friendUserId;
  const MessagesListView(
      {super.key, required this.conversationId, required this.friendUserId});

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
      _scrollToBottom();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_controller.hasClients) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:
          Apis.getMessagesStream(widget.conversationId, widget.friendUserId),
      builder: (context, snapshot) {
        final messages = snapshot.data ?? [];
        if (messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _controller,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            // Mark message as seen if it's from the sender and not seen yet
            if (Apis.user?.uid != message.senderId && !message.isSeen!) {
              Apis.markMessageAsSeen(
                widget.conversationId,
                message.id!,
                Apis.user!.uid, // Pass the current user's ID as recipientId
              );
            }
            return Apis.user?.uid == message.fromId
                ? MyChatMessage(message: message)
                : FriendChatMessage(message: message);
          },
        );
      },
    );
  }
}
