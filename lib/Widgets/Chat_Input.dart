// ignore_for_file: file_names

import 'dart:io';

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:el_shela/Model/Message_Model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatInput extends StatefulWidget {
  final String conversationId;
  final ChatUsers chatUsers;
  const ChatInput(
      {super.key, required this.conversationId, required this.chatUsers});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late final TextEditingController _messageController;
  bool _shoEmoji = false;
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_shoEmoji) {
            setState(() {
              _shoEmoji = false;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 3,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() => _shoEmoji = !_shoEmoji);
                          },
                          icon: const Icon(Icons.emoji_emotions,
                              color: Colors.blueAccent),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onTap: () {
                              if (_shoEmoji) {
                                setState(() => _shoEmoji = !_shoEmoji);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Type Something...',
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final List<XFile> images =
                                await picker.pickMultiImage(imageQuality: 80);
                            // uploading & sending image one by one
                            for (var i in images) {
                              await Apis.sendChatImage(widget.conversationId,
                                  File(i.path), widget.chatUsers);
                            }
                          },
                          icon:
                              const Icon(Icons.image, color: Colors.blueAccent),
                        ),
                        IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 70);
                            if (image != null) {
                              await Apis.sendChatImage(widget.conversationId,
                                  File(image.path), widget.chatUsers);
                            }
                          },
                          icon: const Icon(Icons.camera_alt_rounded,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  elevation: 3,
                  minWidth: 0,
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 5),
                  color: Colors.white,
                  shape: const CircleBorder(),
                  onPressed: () {
                    _sendMessage();
                  },
                  child: const Icon(Icons.send, color: Colors.blueAccent),
                )
              ],
            ),
            if (_shoEmoji)
              EmojiPicker(
                textEditingController:
                    _messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                config: Config(
                  height: 256,
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final time = DateTime.now();
      String messageId = const Uuid().v4();
      // Create a Message object
      Message message = Message(
          msg: _messageController.text,
          senderId: Apis.user?.uid,
          timestamp: time,
          isSeen: false, // Set isSeen to false by default
          id: messageId,
          type: Type.text);

      // Call the function to send the message to Firebase
      Apis.sendMessage(message, widget.conversationId, widget.chatUsers.id!);

      // Clear the text field after sending the message
      _messageController.clear();
    }
  }
}
