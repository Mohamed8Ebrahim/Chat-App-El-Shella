// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/Message_Model.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';
import 'package:hash_cached_image/hash_cached_image.dart';

class FriendChatMessage extends StatelessWidget {
  const FriendChatMessage({
    super.key,
    required this.message,
  });
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(mq.height * .01),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(mq.height * .015),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 224, 254, 190),
                border: Border.all(color: Colors.lightGreen),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: message.type == Type.text
                  ? Text(
                      message.msg!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: HashCachedImage(
                            imageUrl: message.msg ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                    ),
            ),
          ),
          SizedBox(width: mq.width * .01),
          Text(
            Apis.getFormattedTime(
                context: context, time: message.timestamp.toString()),
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class MyChatMessage extends StatelessWidget {
  const MyChatMessage({
    super.key,
    required this.message,
  });
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(mq.height * .01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                Apis.getFormattedTime(
                    context: context, time: message.timestamp.toString()),
                style: const TextStyle(color: Colors.black54),
              ),
              SizedBox(width: mq.width * .01),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(mq.height * .015),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 163, 214, 255),
                    border: Border.all(color: Colors.lightBlue),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: message.type == Type.text
                      ? Text(
                          message.msg!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: HashCachedImage(
                            imageUrl: message.msg ?? '',
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                ),
              ),
            ],
          ),
          if (message.isSeen!)
            Padding(
              padding: EdgeInsets.only(right: mq.width * .02),
              child: const Icon(Icons.done_all_rounded, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
