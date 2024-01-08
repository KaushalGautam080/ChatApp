import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/parameters/complete_profile_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_return_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_up_param.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteSource {
  Future<DataState<SignUpParam>> signUp(SignInParam param);
  Future<DataState<SignInReturnParam>> signIn(SignInParam param);
  Future<DataState<UserModel>> completeProfile(CompleteProfileParam param);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final aInstance = FirebaseAuth.instance;
  final fInstance = FirebaseFirestore.instance;
  final fSInstance = FirebaseStorage.instance;
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
            (value) => debugPrint(
              "new user created",
            ),
          );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return FailureState(
          error: "Auth Error",
          errorMsg: e.toString(),
          errorType: ErrorType.unknown.toString());
    }

    return SuccessState<SignUpParam>(data: sParam);
  }

  @override
  Future<DataState<SignInReturnParam>> signIn(SignInParam param) async {
    late UserModel userModel;
    UserCredential? userCredential;
    SignInReturnParam sParam;
    try {
      userCredential = await aInstance.signInWithEmailAndPassword(
        email: param.email,
        password: param.password,
      );
      String uId = userCredential.user!.uid;
      DocumentSnapshot userData =
          await fInstance.collection("users").doc(uId).get();
      userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      sParam = SignInReturnParam(
          firebaseUser: userCredential.user!, userModel: userModel);
    } on FirebaseAuthException catch (e) {
      print("Firebase Error; $e");
      return FailureState<SignInReturnParam>(
        error: "Auth Error",
        errorMsg: e.toString(),
        errorType: ErrorType.unknown.toString(),
      );
    }
    return SuccessState<SignInReturnParam>(data: sParam);
  }

  @override
  Future<DataState<UserModel>> completeProfile(
      CompleteProfileParam param) async {
    late UserModel userModel;
    try {
      UploadTask uploadTask = fSInstance
          .ref("profilepictures")
          .child(param.userModel.uId.toString())
          .putFile(param.imgFile);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      String fullName = param.fullName;

      param.userModel.fullName = fullName;
      param.userModel.profilePic = imageUrl;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(param.userModel.uId)
          .set(param.userModel.toMap())
          .then((value) => debugPrint("Data Uploaded"));
      DocumentSnapshot userData =
          await fInstance.collection("users").doc(param.userModel.uId).get();
      userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);
      return SuccessState<UserModel>(data: userModel);
    } on FirebaseAuthException catch (e) {
      return FailureState<UserModel>(
        error: "Profile not updated",
        errorMsg: e.toString(),
        errorType: ErrorType.unknown.toString(),
      );
    }
  }
}
