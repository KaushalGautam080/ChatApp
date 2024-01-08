import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_up_param.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthRemoteSource {
  Future<DataState<SignUpParam>> signUp(SignInParam param);
  Future<DataState<UserModel>> signIn(SignInParam param);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final aInstance = FirebaseAuth.instance;
  final fInstance = FirebaseFirestore.instance;
  @override
  Future<DataState<SignUpParam>> signUp(SignInParam param) async {
    UserCredential? userCredential;
    late SignUpParam sParam;

    try {
      userCredential = await aInstance.createUserWithEmailAndPassword(
        email: param.email,
        password: param.password,
      );

      String uId = userCredential.user!.uid;
      UserModel user = UserModel(
        uId: uId,
        email: param.email,
        fullName: "",
        profilePic: "",
      );
      sParam = SignUpParam(userModel: user, firebaseUser: userCredential.user!);
      await fInstance.collection("users").doc(uId).set(user.toMap()).then(
            (value) => print(
              "new user created",
            ),
          );
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return FailureState(
          error: "Auth Error",
          errorMsg: e.toString(),
          errorType: ErrorType.unknown.toString());
    }

    return SuccessState<SignUpParam>(data: sParam);
  }

  @override
  Future<DataState<UserModel>> signIn(SignInParam param) async {
    late UserModel userModel;
    UserCredential? userCredential;
    try {
      userCredential = await aInstance.signInWithEmailAndPassword(
        email: param.email,
        password: param.password,
      );
      String uId = userCredential.user!.uid;
      DocumentSnapshot userData =
          await fInstance.collection("users").doc(uId).get();
      userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      print("Firebase Error; $e");
      return FailureState<UserModel>(
        error: "Auth Error",
        errorMsg: e.toString(),
        errorType: ErrorType.unknown.toString(),
      );
    }
    return SuccessState<UserModel>(data: userModel);
  }
}
