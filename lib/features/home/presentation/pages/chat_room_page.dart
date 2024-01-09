import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel cModel;
  final UserModel userModel;
  final User selfUser;
  const ChatRoomPage({
    super.key,
    required this.targetUser,
    required this.cModel,
    required this.selfUser,
    required this.userModel,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Room"),
      ),
      body: Column(children: [
        Expanded(
          child: Container(),
        ),
        Container(
          child: Row(
            children: [
              Flexible(child: TextField()),
              IconButton(onPressed: () {}, icon: Icon(Icons.send))
            ],
          ),
        )
      ]),
    );
  }
}
