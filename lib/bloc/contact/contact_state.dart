part of 'contact_bloc.dart';

class ContactState {
  final bool isLoading;
  final List<Contact>? list;
  final String? error;
  final bool? isOperationSuccess;

  ContactState({required this.isLoading, this.list, this.error, this.isOperationSuccess});

  ContactState copyWith(
      {bool? isLoading, String? error, List<Contact>? list, bool? isOperationSuccess}) =>
      ContactState(isLoading: isLoading ?? this.isLoading,
          error: error ?? this.error,
          isOperationSuccess: isOperationSuccess ,
          list: list ?? this.list);
}
