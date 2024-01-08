import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<UserModel?> getModelById(String uId) async {
    final fFInstance = FirebaseFirestore.instance;
    DocumentSnapshot docSnap =
        await fFInstance.collection("users").doc(uId).get();
    return UserModel.fromMap(docSnap.data() as Map<String, dynamic>);
  }
}
