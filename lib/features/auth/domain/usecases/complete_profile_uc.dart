import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/core/useCase/use_case_param.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/parameters/complete_profile_param.dart';

import 'package:chat_app/features/auth/domain/repositories/auth_repo.dart';

class CompleteProfileUseCase
    extends UCP<DataState<UserModel>, CompleteProfileParam> {
  final AuthRepo authRepo;
  CompleteProfileUseCase(this.authRepo);

  @override
  Future<DataState<UserModel>> call(CompleteProfileParam param) async {
    return await authRepo.completeProfile(param);
  }
}
