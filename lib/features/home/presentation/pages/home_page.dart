import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/features/home/presentation/pages/chat_room_page.dart';
import 'package:chat_app/features/home/presentation/pages/search_page.dart';
import 'package:chat_app/features/models/chat_model.dart';
import 'package:chat_app/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({
    Key? key,
    required this.userModel,
    required this.firebaseUser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: const Text(
          "Chat App",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModel.uId}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot msgSnap = snapshot.data as QuerySnapshot;
                  return ListView.builder(
                      itemCount: msgSnap.docs.length,
                      itemBuilder: (context, index) {
                        ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                            msgSnap.docs[index].data() as Map<String, dynamic>);
                        Map<String, dynamic> participants =
                            chatRoomModel.participants!;
                        List<String> pKeys = participants.keys.toList();
                        pKeys.remove(widget.userModel.uId);

                        return FutureBuilder(
                            future: FirebaseHelper.getModelById(pKeys[0]),
                            builder: (context, userData) {
                              if (userData.connectionState ==
                                  ConnectionState.done) {
                                UserModel targetUser =
                                    userData.data as UserModel;
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatRoomPage(
                                            targetUser: targetUser,
                                            cModel: chatRoomModel,
                                            selfUser: widget.firebaseUser,
                                            userModel: widget.userModel),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(targetUser.profilePic!)),
                                  title: Text(targetUser.fullName!),
                                  subtitle: (chatRoomModel.lastMessage
                                              .toString() !=
                                          "")
                                      ? Text(chatRoomModel.lastMessage!)
                                      : const Text("Say hi to your new friend"),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      });
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("An error occurred"),
                  );
                } else {
                  return const Center(child: Text("Say hi to your new friend"));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SearchPage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
            ),
          );
        },
        child: const Icon(Icons.search_off_outlined),
      ),
    );
  }
}
