import 'package:equatable/equatable.dart';

class ChatRoomModel extends Equatable {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;
  // DateTime? createdOn;

  ChatRoomModel({
    required this.chatRoomId,
    required this.participants,
    required this.lastMessage,
    // required this.createdOn,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["chatRoomId"];
    participants = map["participants"];
    lastMessage = map["lastMessage"];
    // createdOn = map["createdOn"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomId": chatRoomId,
      "participants": participants,
      "lastMessage": lastMessage,
      // "createdOn": createdOn,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [chatRoomId, participants, lastMessage,];
}
