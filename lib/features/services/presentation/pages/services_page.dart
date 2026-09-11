import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:ilk_uygulama/core/constants/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/service_cubit.dart';
import '../bloc/service_state.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  // Yeni servis ekleme fonksiyonu
  Future<void> _showAddServiceDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final portController = TextEditingController();
    final statusController = TextEditingController(text: 'active');

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Yeni Servis Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Servis Adı'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Port (örn: 8080)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Durum (örn: active)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final port = int.tryParse(portController.text.trim()) ?? 80;
                final status = statusController.text.trim();

                if (name.isEmpty) return;

                try {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('jwt_token');

                  final dio = Dio();
                  await dio.post(
                    '${ApiEndpoints.baseUrl}${ApiEndpoints.services}',
                    data: {
                      "name": name,
                      "port": port,
                      "status": status,
                    },
                    options: Options(
                      headers: {
                        if (token != null) 'Authorization': 'Bearer $token',
                      },
                    ),
                  );

                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);

                  // Listeyi güncelle
                  if (!context.mounted) return;
                  context.read<ServiceCubit>().fetchServices();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Servis başarıyla eklendi! 🎉')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Servis eklenemedi: $e'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sayfa açıldığı an arka planda servisleri çekmeye başla
    context.read<ServiceCubit>().fetchServices();

    return Scaffold(
      appBar: AppBar(title: const Text('Servisler Listesi')),
      body: BlocBuilder<ServiceCubit, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading || state is ServiceInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ServiceLoaded) {
            if (state.services.isEmpty) {
              return const Center(child: Text('Henüz kayıtlı servis bulunmuyor.'));
            }
            return ListView.builder(
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];
                return ListTile(
                  title: Text(service.name),
                  subtitle: Text('Port: ${service.port} - Durum: ${service.status}'),
                  leading: CircleAvatar(child: Text(service.id.toString())),
                );
              },
            );
          } else if (state is ServiceError) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddServiceDialog(context),
        tooltip: 'Yeni Servis Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}