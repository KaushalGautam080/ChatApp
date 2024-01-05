import 'package:flutter/material.dart';

class CusButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final bool loaded;

  final Function() onTap;
  final Color? color;
  const CusButton(
      {super.key,
      required this.text,
      required this.height,
      required this.width,
      required this.onTap,
      this.loaded = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    Widget loadingChild = const CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
    );
    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: loading
              ? () {}
              : () async {
                  if (loaded) {
                    setState(() {
                      loading = true;
                    });
                  }
                  await onTap();
                  if (loaded) {
                    setState(() {
                      loading = false;
                    });
                  }
                },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(15),
            ),
            height: height,
            width: width,
            child: Center(
              child: loading
                  ? loadingChild
                  : Text(
                      text,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),
        );
      },
    );
  }
}
