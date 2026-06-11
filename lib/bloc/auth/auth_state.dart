part of 'auth_bloc.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  AuthState({required this.isLoading,this.error,required this.isSuccess});

  AuthState copyWith({bool? isLoading,String? error, bool? isSuccess}) => AuthState(
    isLoading: isLoading?? this.isLoading,
    error: error,
    isSuccess: isSuccess?? false,
  );
}

