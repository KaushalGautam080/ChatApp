import 'package:flutter/material.dart';

class CusForm extends StatelessWidget {
  final TextEditingController? textEditingController;
  final String? title;
  final TextInputType keyboardType;
  final bool obscureText;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? pOnTap;
  final Function()? sOnTap;
  const CusForm({
    super.key,
    this.textEditingController,
    this.title,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.pOnTap,
    this.sOnTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? suffix;
    if (suffixIcon != null) {
      suffix = InkWell(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ),
        onTap: sOnTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: suffixIcon,
        ),
      );
    }
    return TextFormField(
      controller: textEditingController,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffix,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)))),
    );
  }
}
