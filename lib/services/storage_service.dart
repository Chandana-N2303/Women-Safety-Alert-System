import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String contactsKey = 'trusted_contacts';

  static Future<void> saveContacts(List<Map<String, String>> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedContacts = contacts.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList(contactsKey, encodedContacts);
  }

  static Future<List<Map<String, String>>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final savedContacts = prefs.getStringList(contactsKey) ?? [];

    return savedContacts
        .map((e) => Map<String, String>.from(jsonDecode(e)))
        .toList();
  }
}