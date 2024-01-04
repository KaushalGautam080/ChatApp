import 'package:flutter/material.dart';

class CusButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;

  final Function() onTap;
  final Color? color;
  const CusButton(
      {super.key,
      required this.text,
      required this.height,
      required this.width,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        height: height,
        width: width,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
