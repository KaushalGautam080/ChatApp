import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_up_param.dart';

abstract class AuthRepo {
  Future<DataState<SignUpParam>> signUp(SignInParam param);
  Future<DataState<UserModel>> signIn(SignInParam param);
}
