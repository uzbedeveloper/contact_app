import 'package:contact_app/bloc/contact/contact_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/widgets.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController(text: '+998');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.replaceAll(' ', '').trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('malumot toliq kiriting')));
      return;
    }
    if (!RegExp(r'^\+998\d{9}$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("tel raqam noto'g'ri kiritdiz (+998 ** *** ** **)"),
        ),
      );
      return;
    }

    context.read<ContactBloc>().add(AddContact(name: name, phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state.isOperationSuccess == true) {
          Navigator.pop(context);
        }
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
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
                  const SizedBox(height: 40),
                  Image.asset("assets/img/add.png"),
                  const SizedBox(height: 48),
                  AppTextField(controller: _nameCtrl, hint: 'Name'),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _phoneCtrl,
                    hint: '+998 ',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [UzPhoneFormatter()],
                  ),
                  if (state.error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      state.error!,
                      style: const TextStyle(
                        color: Color(0xFFE85D5D),
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Add',
                    loading: state.isLoading,
                    onPressed: _add,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
