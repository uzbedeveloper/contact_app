import 'package:flutter/material.dart';
import '../../data/source/local/model/contact.dart';
import '../../data/source/local/my_pref.dart';
import '../widgets/widgets.dart';

class UpdateContactScreen extends StatefulWidget {
  final int index;
  final Contact contact;
  final String username;

  const UpdateContactScreen({
    super.key,
    required this.index,
    required this.contact,
    required this.username,
  });

  @override
  State<UpdateContactScreen> createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.contact.name);
    _phoneCtrl = TextEditingController(text: widget.contact.phone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    await MyPref.updateContact(widget.username, widget.index, name, phone);
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
              Image.asset("assets/img/edit.png"),
              const SizedBox(height: 48),
              AppTextField(controller: _nameCtrl, hint: 'Name'),
              const SizedBox(height: 12),
              AppTextField(controller: _phoneCtrl, hint: 'Phone'),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Color(0xFFE85D5D), fontSize: 13)),
              ],
              const SizedBox(height: 24),
              AppButton(label: 'Update', onPressed: _update),
            ],
          ),
        ),
      ),
    );
  }
}