import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/service_cubit.dart';
import '../bloc/service_state.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

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
            return ListView.builder(
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];
                return ListTile(
                  title: Text(service.title),
                  subtitle: Text(service.description),
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
    );
  }
}