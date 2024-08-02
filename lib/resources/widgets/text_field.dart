import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData icon;
  final String? errorText; // New parameter for error text

  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.icon,
    this.errorText, // Initialize the errorText parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            obscureText: isPass,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.black45,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xFFedf0f8),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: Colors.blue,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          if (errorText != null &&
              errorText!.isNotEmpty) // Conditionally show error text
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
