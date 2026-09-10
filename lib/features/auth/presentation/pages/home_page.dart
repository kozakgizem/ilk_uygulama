import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

// Mutlak paket yolları ile User modülü importları
import 'package:ilk_uygulama/features/users/presentation/bloc/user_cubit.dart';
import 'package:ilk_uygulama/features/users/domain/usecases/get_users_usecase.dart';
import 'package:ilk_uygulama/features/users/data/repositories/user_repository_impl.dart';
import 'package:ilk_uygulama/features/users/data/datasources/user_remote_data_source.dart';
import 'package:ilk_uygulama/features/users/presentation/pages/users_page.dart';

// Mutlak paket yolları ile Service modülü importları
import 'package:ilk_uygulama/features/services/presentation/bloc/service_cubit.dart';
import 'package:ilk_uygulama/features/services/domain/usecases/get_services_usecase.dart';
import 'package:ilk_uygulama/features/services/data/repositories/service_repository_impl.dart';
import 'package:ilk_uygulama/features/services/data/datasources/service_remote_data_source.dart';
import 'package:ilk_uygulama/features/services/presentation/pages/services_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          // Sağ üstteki çıkış (logout) butonu
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt_token'); // Token'ı hafızadan siliyoruz
              
              if (!context.mounted) return;

              // Login sayfasına geri dönüp geçmişteki tüm sayfaları siliyoruz
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Başarıyla Giriş Yapıldı! 🎉',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              // Kullanıcılar Sayfasına Giden Buton
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.people),
                label: const Text('Kullanıcıları Görüntüle'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        // Sayfa açılırken Cubit'i ve bağımlılıklarını yüklüyoruz
                        create: (context) => UserCubit(
                          getUsersUseCase: GetUsersUseCase(
                            repository: UserRepositoryImpl(
                              remoteDataSource: UserRemoteDataSourceImpl(dio: Dio()),
                            ),
                          ),
                        ),
                        child: const UsersPage(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Servisler Sayfasına Giden Buton
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.design_services),
                label: const Text('Servisleri Görüntüle'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        // Sayfa açılırken Servis Cubit'ini yüklüyoruz
                        create: (context) => ServiceCubit(
                          getServicesUseCase: GetServicesUseCase(
                            repository: ServiceRepositoryImpl(
                              remoteDataSource: ServiceRemoteDataSourceImpl(dio: Dio()),
                            ),
                          ),
                        ),
                        child: const ServicesPage(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}