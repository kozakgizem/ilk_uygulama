import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'system_status_page.dart';
import 'config_page.dart'; // <-- Eklendi: Konfigürasyon Yönetimi sayfası import edildi
import 'package:ilk_uygulama/core/constants/api_endpoints.dart';

// User modülü importları
import 'package:ilk_uygulama/features/users/presentation/bloc/user_cubit.dart';
import 'package:ilk_uygulama/features/users/domain/usecases/get_users_usecase.dart';
import 'package:ilk_uygulama/features/users/data/repositories/user_repository_impl.dart';
import 'package:ilk_uygulama/features/users/data/datasources/user_remote_data_source.dart';
import 'package:ilk_uygulama/features/users/presentation/pages/users_page.dart';

// Service modülü importları
import 'package:ilk_uygulama/features/services/presentation/bloc/service_cubit.dart';
import 'package:ilk_uygulama/features/services/domain/usecases/get_services_usecase.dart';
import 'package:ilk_uygulama/features/services/data/repositories/service_repository_impl.dart';
import 'package:ilk_uygulama/features/services/data/datasources/service_remote_data_source.dart';
import 'package:ilk_uygulama/features/services/presentation/pages/services_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // /health endpoint'ini kontrol eden metod
  Future<bool> checkSystemHealth() async {
    try {
      final dio = Dio();
      final response = await dio.get('${ApiEndpoints.baseUrl}${ApiEndpoints.health}');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          // Sağ üstte Profilim (/users/me) butonu
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profilim (/users/me)',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => UserCubit(
                      getUsersUseCase: GetUsersUseCase(
                        repository: UserRepositoryImpl(
                          remoteDataSource: UserRemoteDataSourceImpl(dio: Dio()),
                        ),
                      ),
                      userRemoteDataSource: UserRemoteDataSourceImpl(dio: Dio()),
                    )..fetchMyProfile(),
                    child: const UsersPage(),
                  ),
                ),
              );
            },
          ),
          // Çıkış (logout) butonu
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('jwt_token');
              
              if (!context.mounted) return;

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
              const SizedBox(height: 16),
              
              // /health durumunu gösteren rozet
              FutureBuilder<bool>(
                future: checkSystemHealth(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Chip(
                      avatar: SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      label: Text('Sistem Sağlığı Kontrol Ediliyor...'),
                    );
                  }
                  final isHealthy = snapshot.data ?? false;
                  return Chip(
                    avatar: Icon(
                      isHealthy ? Icons.check_circle : Icons.error,
                      color: isHealthy ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    label: Text(
                      isHealthy ? 'Sistem Sağlıklı (/health)' : 'Sisteme Ulaşılamıyor',
                      style: TextStyle(
                        color: isHealthy ? Colors.green.shade800 : Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: isHealthy ? Colors.green.shade50 : Colors.red.shade50,
                    side: BorderSide(color: isHealthy ? Colors.green.shade200 : Colors.red.shade200),
                  );
                },
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
                        create: (context) => UserCubit(
                          getUsersUseCase: GetUsersUseCase(
                            repository: UserRepositoryImpl(
                              remoteDataSource: UserRemoteDataSourceImpl(dio: Dio()),
                            ),
                          ),
                          userRemoteDataSource: UserRemoteDataSourceImpl(dio: Dio()),
                        )..fetchUsers(),
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
              const SizedBox(height: 16),

              // Sistem Durumu ve Loglar Sayfasına Giden Buton
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.monitor_heart),
                label: const Text('Sistem Durumu ve Loglar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SystemStatusPage()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Eklendi: Konfigürasyon Yönetimi Sayfasına Giden Buton
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.settings_applications),
                label: const Text('Konfigürasyon Yönetimi'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfigPage()),
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