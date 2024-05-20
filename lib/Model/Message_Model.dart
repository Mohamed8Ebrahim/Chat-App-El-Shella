// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? id; 
  final String? msg;
  String? fromId;
  final String? senderId;
  final DateTime? timestamp;
  bool? isSeen;
  Type? type;

  Message(
      {required this.id,
      this.fromId,
      required this.msg,
      required this.senderId,
      required this.timestamp,
      this.isSeen = false,
      required this.type});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String?, // Cast to nullable String
        msg: json['msg'] as String?,
        fromId: json['fromId'] as String?,
        senderId: json['senderId'] as String?,
        timestamp: (json['timestamp'] as Timestamp).toDate(),
        isSeen: json['isSeen'] as bool?,
        type:
            json['type'].toString() == Type.image.name ? Type.image : Type.text,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'msg': msg,
        'fromId': fromId,
        'senderId': senderId,
        'timestamp': timestamp,
        'isSeen': isSeen,
        'type': type?.name
      };
}

enum Type { text, image }
