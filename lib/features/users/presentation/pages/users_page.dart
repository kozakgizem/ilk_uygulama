import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcı Yönetimi ve Profil'),
        actions: [
          // Sağ üstte profil verisini yenileme butonu
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profilim (/users/me)',
            onPressed: () {
              context.read<UserCubit>().fetchMyProfile();
            },
          ),
          // Kullanıcı listesini getirme butonu
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Kullanıcı Listesi (/users/)',
            onPressed: () {
              context.read<UserCubit>().fetchUsers();
            },
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (state is UserProfileLoaded) {
            return Center(
              child: Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.user.username,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.user.email,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Chip(
                        label: Text('ID: ${state.user.id}'),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } 
          else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text(user.username),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(child: Text(user.id.toString())),
                );
              },
            );
          } else if (state is UserError) {
            return Center(child: Text('Hata: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}