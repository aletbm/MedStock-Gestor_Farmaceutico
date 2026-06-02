import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.pad = 0,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final double pad;
  
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: pad),
    child:
    TextField(
      controller: controller,
      obscureText: obscureText,
      decoration:InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label
        ),
      ),
    );
  }
}

class CustomTextFieldUnder extends StatelessWidget {
  const CustomTextFieldUnder({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.pad = 0,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final double pad;
  
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: pad),
    child:
    TextField(
      controller: controller,
      obscureText: obscureText,
      decoration:InputDecoration(   
        border: UnderlineInputBorder(),
        labelText: label
        ),
      ),
    );
  }
}