import 'package:chat_app/core/widgets/cus_button.dart';
import 'package:chat_app/core/widgets/cus_form.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/home/presentation/pages/chat_room_page.dart';
import 'package:chat_app/features/models/chat_model.dart';
import 'package:chat_app/injection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage({
    super.key,
    required this.userModel,
    required this.firebaseUser,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController eController = TextEditingController();

  Future<ChatRoomModel> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uId}", isEqualTo: true)
        .where("participants.${targetUser.uId}", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      //fetch existing
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatRoom;
    } else {
      //create new one
      debugPrint("Chat created ");
      ChatRoomModel newChatRoom = ChatRoomModel(
        
        chatRoomId: uuid.v1(),
        participants: {
          widget.userModel.uId.toString(): true,
          targetUser.uId.toString(): true
        },
        lastMessage: "",
      );
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());
      debugPrint("New chatRoom Created");
      chatRoom = newChatRoom;
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Search Messages"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CusForm(
            hintText: "Search Email Address",
            textEditingController: eController,
          ),
          const SizedBox(
            height: 20,
          ),
          CusButton(
            text: "Search",
            height: 60,
            width: 120,
            onTap: () {
              setState(() {});
            },
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("email", isEqualTo: eController.text)
                .where("email", isNotEqualTo: widget.userModel.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot docSnap = snapshot.data as QuerySnapshot;
                  if (docSnap.docs.isNotEmpty) {
                    Map<String, dynamic> userMap =
                        docSnap.docs[0].data() as Map<String, dynamic>;
                    UserModel searchedUser = UserModel.fromMap(userMap);
                    return ListTile(
                      onTap: () async {
                        ChatRoomModel? cModel =
                            await getChatRoomModel(searchedUser);
                        if (cModel != null) {
                          debugPrint("Error: ${cModel.chatRoomId}");
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatRoomPage(
                                targetUser: searchedUser,
                                cModel: cModel,
                                selfUser: widget.firebaseUser,
                                userModel: widget.userModel,
                              ),
                            ),
                          );
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(searchedUser.profilePic!),
                      ),
                      title: Text(searchedUser.fullName!),
                      subtitle: Text(searchedUser.email!),
                      trailing: const Icon(Icons.message_outlined),
                    );
                  } else {
                    return const Text("No results found");
                  }
                } else if (snapshot.hasError) {
                  return const Text("An Error occurred");
                } else {
                  return const Text("No results found");
                }
              } else {
                return const CircularProgressIndicator(
                  strokeAlign: 2,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
