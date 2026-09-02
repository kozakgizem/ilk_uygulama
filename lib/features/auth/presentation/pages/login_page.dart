import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilk_uygulama/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ilk_uygulama/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ilk_uygulama/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilk_uygulama/features/auth/presentation/bloc/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Katmanları birbirine bağlıyoruz (Dependency Injection)
    final datasource = AuthRemoteDatasourceImpl();
    final repository = AuthRepositoryImpl(datasource);
    final loginUseCase = LoginUseCase(repository);

    return BlocProvider(
      create: (context) => AuthCubit(loginUseCase),
      child: Scaffold(
        appBar: AppBar(title: const Text('Clean Architecture Giriş')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Giriş Başarılı: ${state.user.email}')),
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'E-mail (test@test.com deneyin)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Şifre (123456 deneyin)'),
                  ),
                  const SizedBox(height: 24),
                  state is AuthLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                          },
                          child: const Text('Giriş Yap'),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}