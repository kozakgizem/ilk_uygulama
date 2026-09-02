import 'package:dartz/dartz.dart';
import 'package:ilk_uygulama/features/auth/domain/entities/user_entity.dart';
import 'package:ilk_uygulama/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Exception, UserEntity>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}