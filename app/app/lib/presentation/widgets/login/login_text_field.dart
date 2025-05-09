import 'package:flutter/material.dart';

class LoginTextField extends StatefulWidget {
  final String fieldLabel;
  final TextEditingController controller;
  final Widget prefixIcon;
  final Widget? sufixIcon;
  final bool isPassword;

  const LoginTextField(
      {super.key,
      required this.fieldLabel,
      required this.controller,
      required this.prefixIcon,
      this.sufixIcon,
      this.isPassword = false});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool hidePass = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword ? hidePass : false,
      controller: widget.controller,
      decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword 
            ? IconButton(
                onPressed: (){
                  setState(() {
                    hidePass = !hidePass;
                  });
                }, 
                icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility)
              )
            : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          hintText: widget.fieldLabel),
    );
  }
}
