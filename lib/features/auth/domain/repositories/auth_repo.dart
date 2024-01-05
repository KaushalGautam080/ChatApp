import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';

abstract class AuthRepo {
  Future<void> signUp(SignInParam param);
}
