

import 'package:my_project/logic/models/user.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

class UserRegistrationSuccess extends UserState {}

class UserRegistrationFailure extends UserState {
  final String error;

  UserRegistrationFailure(this.error);
}

class LoginInProgress extends UserState {}

class LoginSuccess extends UserState {}

class LoginFailure extends UserState {
  final String error;

  LoginFailure(this.error);
}
