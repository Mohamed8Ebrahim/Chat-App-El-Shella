// ignore_for_file: file_names

import 'package:el_shela/static.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Call Invitation Page Widget
class CallInvitationView extends StatelessWidget {
  const CallInvitationView({
    super.key,
    required this.username,
    required this.callID,
    required this.config,
  });
  final ZegoUIKitPrebuiltCallConfig config;
  final String callID;
  final String username;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: Statics.appID,
        appSign: Statics.appSign,
        userID: '${username}_${DateTime.now().millisecondsSinceEpoch}',
        userName: username,
        plugins: [ZegoUIKitSignalingPlugin()],
        callID: callID,
        config: config
          ..topMenuBar.isVisible = true
          ..topMenuBar.buttons = [
            ZegoCallMenuBarButtonName.minimizingButton,
            ZegoCallMenuBarButtonName.showMemberListButton,
          ]);
  }
}
