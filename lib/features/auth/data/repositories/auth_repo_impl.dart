import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/features/auth/data/datasource/auth_remote_source.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/parameters/complete_profile_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_return_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_up_param.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteSourceImpl _remoteSource = AuthRemoteSourceImpl();

  @override
  Future<DataState<SignUpParam>> signUp(SignInParam param) {
    return _remoteSource.signUp(param);
  }
  
  @override
  Future<DataState<SignInReturnParam>> signIn(SignInParam param) {
    return _remoteSource.signIn(param);
    
  }
  
  @override
  Future<DataState<UserModel>> completeProfile(CompleteProfileParam param) {
    return _remoteSource.completeProfile(param);
  }
}
