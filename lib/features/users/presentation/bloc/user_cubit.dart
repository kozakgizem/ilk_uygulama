import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase getUsersUseCase;

  UserCubit({required this.getUsersUseCase}) : super(UserInitial());

  Future<void> fetchUsers() async {
    emit(UserLoading());
    try {
      final users = await getUsersUseCase();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}