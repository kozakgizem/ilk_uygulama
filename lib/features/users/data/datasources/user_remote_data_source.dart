import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_endpoints.dart'; // Veya direkt URL
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers() async {
    // 1. SharedPreferences'tan kaydedilen token'ı alıyoruz
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // 2. Dio ile istek atarken Token'ı Header'a ekliyoruz
    final response = await dio.get(
      '${ApiEndpoints.baseUrl}/users/', // Kendi FastAPI endpoint adresin
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      List data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Kullanıcılar yüklenemedi');
    }
  }
}