import 'package:chat_app/core/useCase/use_case_param.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';

class SignUpUseCase extends UCP<void, SignInParam> {
  final AuthRepo authRepo;
  SignUpUseCase(this.authRepo);
  @override
  Future<void> call(SignInParam param) async {
    return await authRepo.signUp(param);
  }
}
