import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/core/useCase/use_case_param.dart';

import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_return_param.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';

class SignInUseCase extends UCP<DataState<SignInReturnParam>, SignInParam> {
  final AuthRepo authRepo;
  SignInUseCase(this.authRepo);

  @override
  Future<DataState<SignInReturnParam>> call(SignInParam param) async {
    return await authRepo.signIn(param);
  }
}
