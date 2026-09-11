import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilk_uygulama/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:ilk_uygulama/features/auth/presentation/bloc/auth_state.dart';
import 'home_page.dart'; // <-- Ana sayfa import edildi
import 'register_page.dart'; // <-- Kayıt sayfası import edildi

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastAPI Giriş Ekranı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              // 1. Önce başarı mesajını gösteriyoruz (isteğe bağlı)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Giriş Başarılı! Yönlendiriliyorsunuz...')),
              );
              
              // 2. Başarılı giriş sonrası Ana Sayfaya yönlendirip geri dönüşü kapatıyoruz
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Hata: ${state.message}'), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Şifre'),
                ),
                const SizedBox(height: 24),
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final username = _usernameController.text.trim();
                          final password = _passwordController.text.trim();
                          context.read<AuthCubit>().login(username, password);
                        },
                        child: const Text('Giriş Yap'),
                      ),
                      const SizedBox(height: 12),
                      // Eklendi: Kayıt Ol sayfasına geçiş butonu
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text('Hesabınız yok mu? Kayıt olun'),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}