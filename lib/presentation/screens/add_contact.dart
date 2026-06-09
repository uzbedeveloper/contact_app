import 'package:flutter/material.dart';
import '../../data/source/local/my_pref.dart';
import '../widgets/widgets.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    final username = MyPref.getLoggedInUser() ?? '';
    final res = await MyPref.addContact(username, name, phone);
    if (!res) {
      setState(() => _error = 'A contact with this name or phone already exists');
      return;
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset("assets/img/add.png"),
              const SizedBox(height: 48),
              AppTextField(controller: _nameCtrl, hint: 'Name'),
              const SizedBox(height: 12),
              AppTextField(controller: _phoneCtrl, hint: 'Phone'),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Color(0xFFE85D5D), fontSize: 13)),
              ],
              const SizedBox(height: 24),
              AppButton(label: 'Add', onPressed: _add),
            ],
          ),
        ),
      ),
    );
  }
}