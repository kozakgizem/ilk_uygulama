import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilk_uygulama/core/network/dio_client.dart';
import 'package:ilk_uygulama/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ilk_uygulama/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ilk_uygulama/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilk_uygulama/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:ilk_uygulama/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bağımlılık zincirini kuruyoruz
    final dioClient = DioClient();
    final remoteDataSource = AuthRemoteDataSource(dioClient: dioClient);
    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    final loginUseCase = LoginUseCase(repository);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FastAPI Flutter Auth',
      home: BlocProvider(
        create: (context) => AuthCubit(loginUseCase: loginUseCase),
        child: LoginPage(),
      ),
    );
  }
}