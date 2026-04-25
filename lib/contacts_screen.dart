import 'package:flutter/material.dart';
import 'services/storage_service.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    final savedContacts = await StorageService.getContacts();
    setState(() {
      contacts = savedContacts;
    });
  }

  Future<void> addContact() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) return;

    setState(() {
      contacts.add({
        'name': name,
        'phone': phone,
      });
    });

    await StorageService.saveContacts(contacts);

    nameController.clear();
    phoneController.clear();
  }

  Future<void> deleteContact(int index) async {
    setState(() {
      contacts.removeAt(index);
    });

    await StorageService.saveContacts(contacts);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addContact,
                child: const Text('Add Contact'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: contacts.isEmpty
                  ? const Center(child: Text('No contacts added'))
                  : ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final item = contacts[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['name'] ?? ''),
                            subtitle: Text(item['phone'] ?? ''),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteContact(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}