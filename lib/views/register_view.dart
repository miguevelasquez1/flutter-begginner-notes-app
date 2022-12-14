import 'package:flutter/material.dart';

import 'package:flutter_course_for_beginners/constants/routes.dart';
import 'package:flutter_course_for_beginners/services/auth/auth_exceptions.dart';
import 'package:flutter_course_for_beginners/services/auth/auth_service.dart';
import 'package:flutter_course_for_beginners/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            decoration:
                const InputDecoration(hintText: 'Enter you password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed('/verify-email');
              } on WeakPasswordAuthException {
                showErrorDialog(context, 'The password provided is too weak.');
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(
                    context, 'The account already exists for that email.');
              } on InvalidEamilAuthException {
                showErrorDialog(context, 'The email is invalid.');
              } on GenericAuthException {
                showErrorDialog(context, 'An error occured.');
              } catch (e) {
                showErrorDialog(context, 'Error: $e');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Already have an account? Login'))
        ],
      ),
    );
  }
}
