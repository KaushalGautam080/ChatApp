import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/core/useCase/use_case_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_up_param.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';

class SignUpUseCase extends UCP<DataState<SignUpParam>, SignInParam> {
  final AuthRepo authRepo;
  SignUpUseCase(this.authRepo);
  @override
  Future<DataState<SignUpParam>> call(SignInParam param) async {
    return await authRepo.signUp(param);
  }
}
