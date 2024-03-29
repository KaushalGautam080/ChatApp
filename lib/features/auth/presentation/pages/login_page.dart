import 'package:chat_app/core/resources/data_state.dart';
import 'package:chat_app/core/widgets/cus_button.dart';
import 'package:chat_app/core/widgets/cus_form.dart';
import 'package:chat_app/features/auth/domain/parameters/sign_in_param.dart';
import 'package:chat_app/features/home/presentation/pages/home_page.dart';
import 'package:chat_app/features/auth/presentation/pages/signup_page.dart';
import 'package:chat_app/injection.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController eController = TextEditingController();
  TextEditingController pController = TextEditingController();
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
                CusForm(
                  hintText: "Enter your email",
                  textEditingController: eController,
                ),
                const SizedBox(height: 20),
                CusForm(
                  textEditingController: pController,
                  hintText: "Enter your password",
                  obscureText: obscureText,
                  suffixIcon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
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
                  loaded: true,
                  text: "Login",
                  height: 50,
                  width: 120,
                  onTap: () async {
                    SignInParam param = SignInParam(
                      email: eController.text,
                      password: pController.text,
                    );
                    await Future.delayed(const Duration(seconds: 2));
                    var dState = await sNUC.call(param);
                    if (dState is SuccessState) {
                      debugPrint("Login Successful");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userModel: dState.data!.userModel,
                            firebaseUser: dState.data!.firebaseUser,
                          ),
                        ),
                      );
                    }
                    if (dState is FailureState) {
                      debugPrint("ERROR: ${dState.errorMsg}");
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
          const Text("Don't have an account?"),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
              );
            },
            child: const Text("Sign Up"),
          ),
        ],
      ),
    );
  }
}
