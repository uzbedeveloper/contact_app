import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../hive/adapters/hive_registrar.g.dart';
import 'model/ContactHive.dart';
import 'model/UserHive.dart';
import 'model/contact.dart';


class MyPref {
  static late final Box _settingsBox;
  static late final Box<UserHive> _usersBox;

  static String _contactsBoxName(String username) {
    final safe = username.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return 'contacts_$safe';
  }

  static Future<Box<ContactHive>> _openContactsBox(String username) {
    return Hive.openBox<ContactHive>(_contactsBoxName(username));
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapters();
    _usersBox = await Hive.openBox<UserHive>('users');
    _settingsBox = await Hive.openBox('settings');
  }

  static Future<void> setLoggedIn(String username) async =>
      await _settingsBox.put('logged_in_user', username);

  static String? getLoggedInUser() => _settingsBox.get('logged_in_user') as String?;

  static bool isLoggedIn() => getLoggedInUser() != null;

  static Future<void> logout() async => await _settingsBox.delete('logged_in_user');

  static Future<bool> register(String username, String password) async {
    if (_usersBox.containsKey(username)) return false;
    await _usersBox.put(
      username,
      UserHive(username: username, password: password),
    );
    return true;
  }

  static Future<bool> loginAsync(String username, String password) async {
    final user = _usersBox.get(username);
    return user != null && user.password == password;
  }

  static Future<void> unregister(String username) async {
    await _usersBox.delete(username);
    await Hive.deleteBoxFromDisk(_contactsBoxName(username));
    if (getLoggedInUser() == username) await logout();
  }

  static Future<List<Contact>> getContactsAsync(String username) async {
    final box = await _openContactsBox(username);
    final entries = box.toMap().entries.toList()
      ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
    return entries
        .map((e) => Contact(
      id: e.key.toString(),
      name: e.value.name,
      phone: e.value.phone,
    ))
        .toList();
  }

  static Future<bool> addContact(
      String username, String name, String phone) async {
    final box = await _openContactsBox(username);
    final nameLower = name.toLowerCase();
    final exists = box.values.any(
          (c) => c.phone == phone || c.name.toLowerCase() == nameLower,
    );
    if (exists) return false;

    await box.add(ContactHive(
      name: name,
      phone: phone,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ));
    return true;
  }

  static Future<void> updateContact(
      String username, String docId, String name, String phone) async {
    final box = await _openContactsBox(username);
    final key = int.parse(docId);
    await box.put(
      key,
      ContactHive(
        id: key,
        name: name,
        phone: phone,
        createdAt: box.get(key)?.createdAt ??
            DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  static Future<void> deleteContact(String username, String docId) async {
    final box = await _openContactsBox(username);
    await box.delete(int.parse(docId));
  }
}