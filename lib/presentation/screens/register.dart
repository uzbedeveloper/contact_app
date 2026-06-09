import 'package:flutter/material.dart';
import '../../data/source/local/my_pref.dart';
import '../widgets/widgets.dart';
import 'home.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _error = 'toliq malumot kiriting');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'ikki xil parol yozib quydiz)');
      return;
    }
    if (password.length < 4) {
      setState(() => _error = "kamida 4 ta bo'lsinda parol");
      return;
    }

    final success = await MyPref.register(username, password);
    if (!mounted) return;

    if (success) {
      await MyPref.setLoggedIn(username);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } else {
      setState(() => _error = 'login band ekan)');
    }
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
              const SizedBox(height: 60),
              Image.asset("assets/img/reg.png"),
              const SizedBox(height: 48),
              AppTextField(controller: _userCtrl, hint: 'Username'),
              const SizedBox(height: 12),
              AppTextField(
                controller: _passCtrl,
                hint: 'Password',
                obscure: _obscurePass,
                showToggle: true,
                onToggle: () => setState(() => _obscurePass = !_obscurePass),
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _confirmCtrl,
                hint: 'Confirm Password',
                obscure: _obscureConfirm,
                showToggle: true,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: Color(0xFFE85D5D), fontSize: 13)),
              ],
              const SizedBox(height: 20),
              AppButton(label: 'Register', onPressed: _register),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: 'Do you have an account? ',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Log in',
                        style: TextStyle(
                          color: Color(0xFFE85D5D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}