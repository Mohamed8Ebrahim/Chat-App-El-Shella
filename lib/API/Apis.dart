// ignore_for_file: file_names

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_shela/Model/Message_Model.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // access firebase Storage
  static FirebaseStorage fireStorage = FirebaseStorage.instance;

  static User? get user => auth.currentUser;

  // for checking  if user is exists  or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user?.uid).get()).exists;
  }

  static late ChatUsers me;
// for getting current user info
  static Future<void> getSelfInfo() async {
    return firestore
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUsers.fromJson(user.data()!);
        log('My Data :${user.data()}');
      } else {
        await createNewUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating new user
  static Future<void> createNewUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUsers(
      id: user?.uid,
      name: user?.displayName.toString(),
      email: user?.email.toString(),
      about: "I'm using chat",
      image: user?.photoURL.toString(),
      isOnline: false,
      lastActive: time,
      pushToken: '',
      createdAt: time,
    );
    await firestore.collection("users").doc(user?.uid).set(chatUser.toJson());
  }

  //get all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user?.uid)
        .snapshots();
  }

  //update  profile data of the user
  static Future<void> updateUserData() async {
    await firestore.collection('users').doc(user?.uid).update({
      'name': me.name!,
      'about': me.about!,
    });
  }

  static Future<void> updateActiveStatus(bool isOnline) {
    return firestore.collection("users").doc(user?.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  // Update profile picture for user
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = fireStorage.ref().child('profile picture/${user?.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user?.uid).update({
      'image': me.image,
    });
  }

  //----------------- For ChatView---------------------------
  static void sendMessage(
      Message message, String conversationId, String recipientId) async {
    try {
      await firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'id': message.id,
        'body': message.msg,
        'senderId': Apis.user?.uid,
        'recipientId': recipientId,
        'timestamp': message.timestamp,
        'isSeen': false,
        'type': message.type.toString()
      }).then((docRef) {
        // Retrieve the ID of the newly added document
        String messageId = docRef.id;
        // Use the messageId to update the message with the recipient's ID
        docRef.update({'id': messageId});
      });
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  static Stream<List<Message>> getMessagesStream(
      String conversationId, String friendUserId) {
    return firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Set the fromId field based on the senderId stored in Firestore
        String senderId = data['senderId'];
        String fromId =
            senderId == Apis.user?.uid ? Apis.user!.uid : friendUserId;
        // Determine message type based on 'type' field
        Type messageType =
            data['type'] == Type.image.toString() ? Type.image : Type.text;
        return Message(
          id: doc.id,
          msg: data['body'],
          senderId: senderId,
          timestamp: data['timestamp'].toDate(),
          isSeen: data['isSeen'],
          fromId: fromId,
          type: messageType,
        );
      }).toList();
    });
  }

  static void markMessageAsSeen(
      String conversationId, String messageId, String recipientId) async {
    try {
      await firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true, 'recipientId': recipientId});
    } catch (e) {
      debugPrint('Error marking message as seen: $e');
    }
  }

  static String generateConversationId(String? userId1, String? userId2) {
    // Check if either userId1 or userId2 is null
    if (userId1 == null || userId2 == null) {
      throw ArgumentError('User IDs cannot be null.');
    }

    // Sort the user IDs alphabetically to ensure consistency
    List<String> sortedUserIds = [userId1, userId2]..sort();

    // Concatenate the sorted user IDs to create the conversationId
    String conversationId = sortedUserIds.join('_');

    return conversationId;
  }

  // get only last message of  conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String conversationId) {
    return firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  // get last message
  static String getLastMessageTime(BuildContext context, String time,
      {bool showYear = false}) {
    if (time.isNotEmpty) {
      final int millisecondsSinceEpoch = int.parse(time);
      final DateTime sent =
          DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
      final DateTime now = DateTime.now();

      if (now.year == sent.year &&
          now.month == sent.month &&
          now.day == sent.day) {
        // Check if sent is today
        return TimeOfDay.fromDateTime(sent).format(context);
      } else {
        return showYear
            ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
            : '${sent.day} ${_getMonth(sent)}';
      }
    } else {
      return "No Message Yet";
    }
  }

  // get Formatted Time
  static String getFormattedTime({
    required BuildContext context,
    required String time,
  }) {
    final DateTime date = DateTime.parse(time);
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // get formatted last active time of user in chat screen
  static String getLastActiveTime({
    required BuildContext context,
    required String lastActive,
  }) {
    final int i = int.tryParse(lastActive) ?? -1;
    // if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    final DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    final DateTime now = DateTime.now();

    // Convert server time to local time
    final DateTime localTime = time.toLocal();

    // Calculate the difference between now and the last active time
    final Duration difference = now.difference(localTime);
    if (difference.inSeconds < 60) {
      return 'Last seen just now';
    } else if (difference.inMinutes < 60) {
      return 'Last seen ${difference.inMinutes} minute(s) ago';
    } else if (difference.inHours < 24) {
      return 'Last seen ${difference.inHours} hour(s) ago';
    } else if (difference.inDays == 1) {
      return 'Last seen yesterday at ${DateFormat.jm().format(localTime)}';
    } else if (difference.inDays < 7) {
      return 'Last seen ${difference.inDays} day(s) ago';
    } else {
      return 'Last seen on ${DateFormat('d MMM').format(localTime)} at ${DateFormat.jm().format(localTime)}';
    }
  }

  //get month name from month index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  // send chat image
  static Future<void> sendChatImage(
      String conversationId, File file, ChatUsers chatUsers) async {
    final ext = file.path.split('.').last;

    final ref = fireStorage.ref().child(
        'images/$conversationId/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();

    // Create a Message object with image type
    Message message = Message(
      id: const Uuid().v4(),
      msg: imageUrl,
      senderId: Apis.user?.uid,
      timestamp: DateTime.now(),
      isSeen: false,
      type: Type.image, // Set type to image
    );

    // Call sendMessage with the image Message
    sendMessage(message, conversationId, chatUsers.id ?? '');
  }
}
