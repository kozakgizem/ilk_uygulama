import '../../domain/entities/user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserEntity> users;
  UserLoaded(this.users);
}

// Eklendi: Aktif kullanıcı profilini tutmak için
class UserProfileLoaded extends UserState {
  final UserEntity user;
  UserProfileLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}