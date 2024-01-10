import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/models/chat_model.dart';
import 'package:chat_app/features/models/message_model.dart';
import 'package:chat_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController mController = TextEditingController();

  void sendMessage() async {
    String message = mController.text.trim();
    mController.clear();
    if (message != "") {
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uId,
        createdOn: DateTime.now(),
        text: message,
        seen: false,
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.cModel.chatRoomId)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      widget.cModel.lastMessage = message;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.cModel.chatRoomId)
          .set(widget.cModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage:
                  NetworkImage(widget.targetUser.profilePic.toString()),
            ),
            const SizedBox(width: 20),
            Text(widget.targetUser.fullName.toString())
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Column(children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chatrooms")
                    .doc(widget.cModel.chatRoomId)
                    .collection("messages")
                    .orderBy("createdOn", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      debugPrint(
                          ":dataSnapshot.doc: ${dataSnapshot.docs.isEmpty}");
                      return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            debugPrint("Length: ${dataSnapshot.docs.length}");
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            print("Current Message: $currentMessage");

                            return Row(
                              mainAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uId)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: (currentMessage.sender ==
                                              widget.userModel.uId)
                                          ? Colors.blue
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(40)),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 1,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Center(
                                    child: Text(
                                      currentMessage.text.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else if (snapshot.hasError) {
                      return const Text(
                          "An error Occurred. Please check your internet connection!");
                    } else {
                      return const Text("Say hi! to your new friend");
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          Row(
            children: [
              Flexible(
                  child: TextField(
                decoration: const InputDecoration(hintText: "Enter message"),
                controller: mController,
                maxLines: null,
              )),
              IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: const Icon(Icons.send))
            ],
          )
        ]),
      ),
    );
  }
}
