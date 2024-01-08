import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/core/widgets/cus_button.dart';
import 'package:chat_app/core/widgets/cus_form.dart';

import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';

import 'package:chat_app/features/auth/presentation/pages/complete_profile.dart';
import 'package:chat_app/injection.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController eController = TextEditingController();
  TextEditingController pController = TextEditingController();
  TextEditingController cPController = TextEditingController();

  bool obscureText = true;
  bool obscureText1 = true;
  bool loading = false;
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
                CusForm(
                  hintText: "Enter your email",
                  textEditingController: eController,
                ),
                const SizedBox(height: 20),
                CusForm(
                  textEditingController: pController,
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
                  textEditingController: cPController,
                  hintText: "Confirm your password",
                  obscureText: obscureText1,
                  suffixIcon: const Icon(
                    Icons.password,
                  ),
                  sOnTap: () {
                    setState(() {
                      obscureText1 = !obscureText1;
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                CusButton(
                  loaded: true,
                  text: "SignUp",
                  height: 50,
                  width: 120,
                  onTap: () async {
                    SignInParam param = SignInParam(
                      email: eController.text,
                      password: pController.text,
                    );

                    await Future.delayed(const Duration(seconds: 3));

                    var dState = await sUc.call(param);
                    debugPrint("AAAAAAAAAAAAAMMMMMMM : $dState");
                    if (dState is SuccessState) {
                      debugPrint("AAAAAAAAAAAAA : $dState");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CProfile(
                            uModel: dState.data!.userModel,
                            firebaseUser: dState.data!.firebaseUser,
                          ),
                        ),
                      );
                    }
                    if (dState is FailureState) {
                      debugPrint("FFFFFFFFFFFF : ${dState.errorMsg}");
                    }
                  },
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
