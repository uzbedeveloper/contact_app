import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/contact.dart';

class MyPref {
  static final _db = FirebaseFirestore.instance;
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setLoggedIn(String username) async {
    await _prefs.setString('logged_in_user', username);
  }

  static String? getLoggedInUser() => _prefs.getString('logged_in_user');

  static bool isLoggedIn() => getLoggedInUser() != null;

  static Future<void> logout() async {
    await _prefs.remove('logged_in_user');
  }


  static Future<bool> register(String username, String password) async {
    final doc = await _db.collection('users').doc(username).get();
    if (doc.exists) return false;
    await _db.collection('users').doc(username).set({'password': password});
    return true;
  }

  static Future<bool> loginAsync(String username, String password) async {
    final doc = await _db.collection('users').doc(username).get();
    if (!doc.exists) return false;
    return doc.data()?['password'] == password;
  }

  static Future<void> unregister(String username) async {
    final contacts = await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .get();
    for (final doc in contacts.docs) {
      await doc.reference.delete();
    }
    await _db.collection('users').doc(username).delete();
    if (getLoggedInUser() == username) await logout();
  }


  static Future<List<Contact>> getContactsAsync(String username) async {
    final snapshot = await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .orderBy('createdAt')
        .get();
    return snapshot.docs
        .map((d) => Contact.fromMap({...d.data(), 'id': d.id}))
        .toList();
  }

  static Future<bool> addContact(
      String username, String name, String phone) async {
    final phoneCheck = await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .where('phone', isEqualTo: phone)
        .get();
    if (phoneCheck.docs.isNotEmpty) return false;

    final nameCheck = await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .where('nameLower', isEqualTo: name.toLowerCase())
        .get();
    if (nameCheck.docs.isNotEmpty) return false;

    await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .add({
      'name': name,
      'nameLower': name.toLowerCase(),
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return true;
  }

  static Future<void> updateContact(
      String username, String docId, String name, String phone) async {
    await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .doc(docId)
        .update({
      'name': name,
      'nameLower': name.toLowerCase(),
      'phone': phone,
    });
  }

  static Future<void> deleteContact(String username, String docId) async {
    await _db
        .collection('users')
        .doc(username)
        .collection('contacts')
        .doc(docId)
        .delete();
  }
}