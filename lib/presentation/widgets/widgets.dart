import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool showToggle;
  final VoidCallback? onToggle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.showToggle = false,
    this.onToggle,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.black87, fontSize: 16),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: showToggle
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggle,
        )
            : IconButton(
          icon: const Icon(Icons.close, color: Colors.grey, size: 18),
          onPressed: () => controller.clear(),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE85D5D),
          disabledBackgroundColor: const Color(0xFFE85D5D).withOpacity(0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: loading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class UzPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (!digits.startsWith('998')) digits = '998';
    if (digits.length > 12) digits = digits.substring(0, 12);

    final local = digits.substring(3);
    final buf = StringBuffer('+998');

    if (local.isNotEmpty) {
      buf.write(' ');
      buf.write(local.substring(0, local.length.clamp(0, 2)));
    }
    if (local.length > 2) {
      buf.write(' ');
      buf.write(local.substring(2, local.length.clamp(2, 5)));
    }
    if (local.length > 5) {
      buf.write(' ');
      buf.write(local.substring(5, local.length.clamp(5, 7)));
    }
    if (local.length > 7) {
      buf.write(' ');
      buf.write(local.substring(7, local.length.clamp(7, 9)));
    }

    final formatted = buf.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}