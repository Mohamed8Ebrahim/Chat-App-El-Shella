// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Widgets/Chat_Input.dart';
import 'package:el_shela/Widgets/CustomChatAppBar.dart';
import 'package:el_shela/Widgets/Messages_Listview.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chatUsers});
  final ChatUsers chatUsers;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final String conversationId;
  late final String friendUserId; // Add friendUserId here
  @override
  void initState() {
    super.initState();
    conversationId = Apis.generateConversationId(
      Apis.user?.uid, // Your user ID
      widget.chatUsers.id, // Friend's user ID
    );
    friendUserId = widget.chatUsers.id!; // Assign the friend's user ID here
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 191, 252, 228),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 189, 251, 119),
            toolbarHeight: 60,
            elevation: 3,
            flexibleSpace: CustomChatAppBar(
              chatUsers: widget.chatUsers,
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: MessagesListView(
                  conversationId: conversationId,
                  friendUserId: friendUserId, // Pass friendUserId here
                ),
              ),
              ChatInput(
                  conversationId: conversationId, chatUsers: widget.chatUsers),
            ],
          ),
        ),
      ),
    );
  }
}
