import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpParam {
  final UserModel userModel;
  final User firebaseUser;

  SignUpParam({
    required this.userModel,
    required this.firebaseUser,
  });
}
