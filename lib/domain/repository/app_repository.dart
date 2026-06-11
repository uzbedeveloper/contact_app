import '../../data/source/local/model/contact.dart';

abstract class AppRepository {

  Future<bool> register(String username, String password);
  Future<void> logout();
  Future<bool> loginAsync(String username, String password);
  Future<void> unregister(String username);
  Future<void> setLoggedIn(String username);
  String? getLoggedInUser();
  bool isLoggedIn();

  Future<List<Contact>> getContactsAsync(String username);
  Future<bool> addContact(
      String username, String name, String phone);
  Future<void> updateContact(
      String username, String docId, String name, String phone);
  Future<void> deleteContact(String username, String docId);

}