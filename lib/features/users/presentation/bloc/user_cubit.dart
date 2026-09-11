import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/user_remote_data_source.dart'; // DataSource'u import ediyoruz
import '../../domain/usecases/get_users_usecase.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase getUsersUseCase;
  final UserRemoteDataSource userRemoteDataSource; // Eklendi

  UserCubit({
    required this.getUsersUseCase,
    required this.userRemoteDataSource,
  }) : super(UserInitial());

  Future<void> fetchUsers() async {
    emit(UserLoading());
    try {
      final users = await getUsersUseCase();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // Eklendi: Aktif kullanıcı profilini çekme fonksiyonu
  Future<void> fetchMyProfile() async {
    emit(UserLoading());
    try {
      final user = await userRemoteDataSource.getMe();
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}