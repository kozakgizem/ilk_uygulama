import 'package:ilk_uygulama/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ilk_uygulama/features/auth/domain/repositories/auth_repository.dart';

// Domain katmanındaki soyut AuthRepository kuralını gerçeğe dönüştüren sınıf
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> login(String username, String password) async {
    // İşlemi gerçek uzak veri kaynağına (API) yönlendiriyoruz ve token döndürüyoruz
    return await remoteDataSource.login(username, password);
  }
}