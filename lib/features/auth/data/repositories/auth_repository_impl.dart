import 'package:dartz/dartz.dart';
import 'package:ilk_uygulama/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ilk_uygulama/features/auth/domain/entities/user_entity.dart';
import 'package:ilk_uygulama/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Exception, UserEntity>> login(String email, String password) async {
    try {
      final userModel = await remoteDatasource.login(email, password);
      return Right(userModel); // Başarılı olursa Entity olarak döndür
    } catch (e) {
      return Left(Exception(e.toString())); // Hata olursa Left ile yakala
    }
  }
}