// ignore_for_file: file_names

import 'dart:developer';
import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Views/Profile_View.dart';
import 'package:el_shela/Widgets/Chat_User_Card.dart';
import 'package:el_shela/Widgets/My_Search_Delegat.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  List<ChatUsers> users = [];
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();

    Apis.updateActiveStatus(true);
// Listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    SystemChannels.lifecycle.setMessageHandler((message) {
      log("Message: $message");

      if (Apis.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          Apis.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          Apis.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 189, 251, 119),
        elevation: 1,
        toolbarHeight: mq.height * .1,
        title: const Text(
          'El Shella',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.home,
              size: 30,
            )),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                showSearch(context: context, delegate: MySearchDelegat(users));
              });
            },
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileView(userData: Apis.me),
                ),
              );
            },
            icon: const Icon(
              Icons.more_vert,
              size: 30,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Apis.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              final userData = snapshot.data!.docs;
              users.clear();
              for (var doc in userData) {
                log('Data: $userData');
                ChatUsers user = ChatUsers.fromJson(doc.data());
                users.add(user);
              }
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          }

          if (users.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * .02, vertical: mq.height * .02),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ChatUserCard(
                    user: users[index],
                  );
                },
              ),
            );
          } else {
            return Text('No Connections Found!',
                style: Theme.of(context).textTheme.titleLarge);
          }
        },
      ),
    );
  }
}
