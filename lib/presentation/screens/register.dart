import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Toliq malumot kiriting')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ikki xil parol yozib quydiz)')),
      );
      return;
    }
    if (password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("kamida 4 ta bo'lsinda parol")),
      );
      return;
    }

    context.read<AuthBloc>().add(Register(username: username,password: password));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state.isSuccess) {
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    }
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
    }
  },
  builder: (context, state) {
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
              if (state.error != null) ...[
                const SizedBox(height: 10),
                Text(state.error!, style: const TextStyle(color: Color(0xFFE85D5D), fontSize: 13)),
              ],
              const SizedBox(height: 20),
              AppButton(label: 'Register', loading: state.isLoading, onPressed: _register),
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
                        style: TextStyle(color: Color(0xFFE85D5D), fontWeight: FontWeight.bold),
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
  },
);
  }
}