import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthRemoteSource {
  Future<void> signUp(SignInParam param);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final aInstance = FirebaseAuth.instance;
  final fInstance = FirebaseFirestore.instance;
  @override
  Future<void> signUp(SignInParam param) async {
    UserCredential? userCredential;
    try {
      userCredential = await aInstance.createUserWithEmailAndPassword(
        email: param.email,
        password: param.password,
      );
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    if (userCredential != null) {
      String uId = userCredential.user!.uid;
      UserModel user = UserModel(
        uId: uId,
        email: param.email,
        fullName: "",
        profilePic: "",
      );
      await fInstance.collection("users").doc(uId).set(user.toMap()).then(
            (value) => print(
              "new user created",
            ),
          );
    }
  }
}
