// ignore_for_file: file_names

import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Widgets/Chat_User_Card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchDelegat extends SearchDelegate {
  List<ChatUsers> searchResult = [];
  final List<ChatUsers> users;

  MySearchDelegat(this.users);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(CupertinoIcons.clear_circled_solid),
        onPressed: () {
          Navigator.pop(context);
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Display search results based on the query
    List<ChatUsers> results = searchResult.where((user) {
      return user.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ChatUserCard(user: results[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Filter suggestions based on the query
    List<ChatUsers> suggestions = users.where((user) {
      return user.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ChatUserCard(user: suggestions[index]);
      },
    );
  }
}
