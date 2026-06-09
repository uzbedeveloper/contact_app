import 'package:shared_preferences/shared_preferences.dart';

import 'model/contact.dart';

class MyPref {
  static late final SharedPreferences _myPref;

  static Future<void> init() async {
    _myPref = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(String username) async =>
      await _myPref.setString('logged_in_user', username);

  static String? getLoggedInUser() => _myPref.getString('logged_in_user');

  static bool isLoggedIn() => getLoggedInUser() != null;

  static Future<void> logout() async =>
      await _myPref.remove('logged_in_user');

  static Future<bool> register(String username, String password) async {
    if (_myPref.containsKey('user_${username}_password')) return false;
    await _myPref.setString('user_${username}_password', password);
    return true;
  }

  static bool login(String username, String password) {
    return _myPref.getString('user_${username}_password') == password;
  }

  static Future<void> unregister(String username) async {
    await _myPref.remove('user_${username}_password');
    await _myPref.remove('user_${username}_contact_names');
    await _myPref.remove('user_${username}_contact_phones');
    if (getLoggedInUser() == username) await logout();
  }

  static List<String> getContactNames(String username) =>
      _myPref.getStringList('user_${username}_contact_names') ?? [];

  static List<String> getContactPhones(String username) =>
      _myPref.getStringList('user_${username}_contact_phones') ?? [];

  static List<Contact> getContacts(String username) {
    final names = getContactNames(username);
    final phones = getContactPhones(username);
    return List.generate(
      names.length,
          (i) => Contact(name: names[i], phone: phones[i]),
    );
  }

  static Future<bool> addContact(String username, String name, String phone) async {
    final names = getContactNames(username);
    final phones = getContactPhones(username);
    if (names.any((n) => n.toLowerCase() == name.toLowerCase()) || phones.contains(phone)) return false;
    await _myPref.setStringList('user_${username}_contact_names', names..add(name));
    await _myPref.setStringList('user_${username}_contact_phones', phones..add(phone));
    return true;
  }

  static Future<void> updateContact(String username, int index, String name, String phone) async {
    final names = getContactNames(username)..[index] = name;
    final phones = getContactPhones(username)..[index] = phone;
    await _myPref.setStringList('user_${username}_contact_names', names);
    await _myPref.setStringList('user_${username}_contact_phones', phones);
  }

  static Future<void> deleteContact(String username, int index) async {
    final names = getContactNames(username)..removeAt(index);
    final phones = getContactPhones(username)..removeAt(index);
    await _myPref.setStringList('user_${username}_contact_names', names);
    await _myPref.setStringList('user_${username}_contact_phones', phones);
  }
}