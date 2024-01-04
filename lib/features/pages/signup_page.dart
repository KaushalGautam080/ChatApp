import 'package:chat_app/core/widgets/cus_button.dart';
import 'package:chat_app/core/widgets/cus_form.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CusForm(hintText: "Enter your email"),
                const SizedBox(height: 20),
                CusForm(
                  hintText: "Enter your password",
                  obscureText: obscureText,
                  suffixIcon: const Icon(
                    Icons.password,
                  ),
                  sOnTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CusForm(
                  hintText: "Confirm your password",
                  obscureText: obscureText,
                  suffixIcon: const Icon(
                    Icons.password,
                  ),
                  sOnTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                CusButton(
                  text: "SignUp",
                  height: 50,
                  width: 120,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
        bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account?"),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Log In"),
          ),
        ],
      ),
    );
  }
}
