part of 'contact_bloc.dart';

abstract class ContactEvent {}

class LoadContacts extends ContactEvent{}

class AddContact extends ContactEvent {
  final String name;
  final String phone;

  AddContact({required this.name, required this.phone});
}

class EditContact extends ContactEvent {
  final String docId;
  final String name;
  final String phone;

  EditContact({
    required this.name,
    required this.docId,
    required this.phone,
  });
}

class DeleteContact extends ContactEvent {
  final String docId;

  DeleteContact({required this.docId});
}
