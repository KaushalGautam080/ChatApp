
import 'package:chat_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:chat_app/features/auth/domain/usecases/sign_in_uc.dart';
import 'package:chat_app/features/auth/domain/usecases/sign_up_uc.dart';
//repositories
final authRepoImpl = AuthRepoImpl();

//use case
final sUc = SignUpUseCase(authRepoImpl);
final sNUC = SignInUseCase(authRepoImpl);