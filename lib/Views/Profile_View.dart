// ignore_for_file: file_names

import 'package:el_shela/API/Apis.dart';
import 'package:el_shela/Helper/Show_Dialog.dart';
import 'package:el_shela/Model/chat_user_model.dart';
import 'package:el_shela/Widgets/Custom_Profil_Text_Fields.dart';
import 'package:el_shela/Widgets/Custom_Profile_Image.dart';
import 'package:el_shela/Widgets/Elevated_Button_Icon.dart';
import 'package:el_shela/Widgets/Floating_Button_Logout.dart';
import 'package:el_shela/main.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.userData});
  final ChatUsers userData;
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 189, 251, 119),
          elevation: 1,
          toolbarHeight: mq.height * .1,
          title: const Text(
            'Profile',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
        floatingActionButton: const FloatingButtonLogout(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CustomProfileImage(user: widget.userData),
                SizedBox(height: mq.height * .02),
                Text(
                  widget.userData.email!,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: mq.height * .05),
                Form(
                  key: _formKey,
                  child: CustomProfilTextFields(widget: widget),
                ),
                SizedBox(height: mq.height * .02),
                ElevatedButtonIcon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Apis.updateUserData();

                      ShowDialog().showDialogMes("Update Saved", context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
