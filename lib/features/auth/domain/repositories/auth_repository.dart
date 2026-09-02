import 'package:ilk_uygulama/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart'; // İleride hata yönetimi için kullanacağız

abstract class AuthRepository {
  Future<Either<Exception, UserEntity>> login(String email, String password);
}