import 'package:flutter/material.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../widgets/widgets.dart';
import 'home.dart';
import 'register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('username kiriting'),duration: Durations.short4,));
      return;
    }
    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('parol kiriting'),duration: Durations.short4,));
      return;
    }
    if (password.length<4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('parol 4 ta dan kop bolishi kerak ediku !!!'),duration: Durations.short4,));
      return;
    }

    context.read<AuthBloc>().add(Login(username: username,password:password));
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
              Image.asset("assets/img/phone.png"),
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
              if (state.error != null) ...[
                const SizedBox(height: 10),
                Text(state.error!, style: const TextStyle(color: Color(0xFFE85D5D), fontSize: 13)),
              ],
              const SizedBox(height: 20),
              AppButton(label: 'Log In', loading: state.isLoading, onPressed: _login),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: RichText(
                  text: const TextSpan(
                    text: "Don't have an account yet? ",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(
                        text: 'Sign up here',
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