import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? errorInput;
  final TextEditingController inputController ;
  final String hintText;
  final IconData? icon;
  final void Function()? onPressed;
  final bool obsecureText;

  const MyTextField(
      {super.key,
        required this.hintText,
        this.icon,
        this.onPressed,
        this.obsecureText = false, required this.inputController, this.errorInput});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: TextFormField(
            controller: inputController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return errorInput;
              }
              return null;
            },
            obscureText: obsecureText,
          ),
        ),
        IconButton(onPressed: onPressed, icon: Icon(icon))
      ]),
    );
  }
}
