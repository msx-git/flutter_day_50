import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day_50/controllers/users_controller.dart';
import 'package:flutter_day_50/utils/extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/show_loader.dart';
import '../../widgets/my_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  submit() async {
    if (formKey.currentState!.validate()) {
      Messages.showLoadingDialog(context);
      await context
          .read<AuthController>()
          .register(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then(
        (_) async {
          await context
              .read<UsersController>()
              .addUser(
                name: nameController.text.trim(),
                email: emailController.text.trim(),
                userId: FirebaseAuth.instance.currentUser!.uid,
              )
              .then(
            (value) {
              nameController.clear();
              emailController.clear();
              passwordController.clear();
              passwordConfirmController.clear();
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: Text(
          "Welcome!",
          style: GoogleFonts.poppins(fontSize: 22),
        ),
        backgroundColor: const Color(0xffFFFFFF),
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              20.height,
              MyTextFormField(
                controller: nameController,
                label: "Name",
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Enter name address!";
                  }
                  return null;
                },
              ),
              8.height,
              MyTextFormField(
                controller: emailController,
                label: "Email",
                isEmail: true,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Enter email address!";
                  }
                  return null;
                },
              ),
              8.height,
              MyTextFormField(
                controller: passwordController,
                label: "Password",
                isPassword: true,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Enter password!";
                  }
                  return null;
                },
              ),
              8.height,
              MyTextFormField(
                controller: passwordConfirmController,
                label: "Confirm Password",
                isPassword: true,
                isLast: true,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Enter confirm password!";
                  }
                  if (passwordController.text !=
                      passwordConfirmController.text) {
                    return "Passwords didn't match!";
                  }
                  return null;
                },
              ),
              20.height,
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: submit,
                  child: Text(
                    "Join",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
