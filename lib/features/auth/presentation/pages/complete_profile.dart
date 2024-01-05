import 'package:chat_app/core/widgets/cus_button.dart';
import 'package:chat_app/core/widgets/cus_form.dart';
import 'package:flutter/material.dart';

class CProfile extends StatefulWidget {
  const CProfile({Key? key}) : super(key: key);

  @override
  State<CProfile> createState() => _CProfileState();
}

class _CProfileState extends State<CProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
               CircleAvatar(
                radius: 60,
                child: IconButton(
                  onPressed:(){},
                  icon :const Icon(Icons.person,
                  size: 60,)
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const CusForm(hintText: "Full Name"),
              const SizedBox(
                height: 50,
              ),
              CusButton(
                text: "Complete",
                height: 60,
                width: 120,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
