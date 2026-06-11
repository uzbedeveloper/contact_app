part of 'auth_bloc.dart';

abstract class AuthEvent {}

class Login extends AuthEvent{
  final String username;
  final String password;

  Login({required this.username, required this.password});
}
class Register extends AuthEvent{
  final String username;
  final String password;

  Register({required this.username, required this.password});
}
class Unregister extends AuthEvent{}

class Logout extends AuthEvent{}