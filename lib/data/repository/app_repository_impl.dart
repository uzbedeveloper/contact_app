import 'package:contact_app/data/source/local/model/contact.dart';
import 'package:contact_app/data/source/local/my_pref.dart';
import 'package:contact_app/domain/repository/app_repository.dart';

class AppRepositoryImpl implements AppRepository{
  @override
  Future<bool> addContact(String username, String name, String phone) =>
      MyPref.addContact(username, name, phone);

  @override
  Future<void> deleteContact(String username, String docId) =>
      MyPref.deleteContact(username, docId);

  @override
  Future<List<Contact>> getContactsAsync(String username) =>
      MyPref.getContactsAsync(username);

  @override
  String? getLoggedInUser() => MyPref.getLoggedInUser();

  @override
  bool isLoggedIn() => MyPref.isLoggedIn();

  @override
  Future<bool> loginAsync(String username, String password) =>
      MyPref.loginAsync(username, password);

  @override
  Future<void> logout() => MyPref.logout();

  @override
  Future<bool> register(String username, String password) =>MyPref.register(username, password);

  @override
  Future<void> setLoggedIn(String username) => MyPref.setLoggedIn(username);

  @override
  Future<void> unregister(String username) => MyPref.unregister(username);

  @override
  Future<void> updateContact(String username, String docId, String name, String phone) => MyPref.updateContact(username, docId, name, phone);
  
}