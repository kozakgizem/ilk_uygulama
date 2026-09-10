import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sayfa açıldığı an arka planda kullanıcıları çekmeye başla
    context.read<UserCubit>().fetchUsers();

    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcılar Listesi')),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
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