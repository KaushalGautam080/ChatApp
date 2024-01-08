import 'dart:io';

import 'package:chat_app/features/auth/data/models/user_model.dart';

class CompleteProfileParam {
  final String fullName;
  final UserModel userModel;
  final File imgFile;

  const CompleteProfileParam({
    required this.fullName,
    required this.userModel,
    required this.imgFile,
  });
}
