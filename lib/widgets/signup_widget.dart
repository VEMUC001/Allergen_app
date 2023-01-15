import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';

import '../main.dart';
import '../utils.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn
  }) : super(key: key);

  final Function() onClickedSignIn;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void disponse() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(16),
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          FlutterLogo(size: 120),
          SizedBox(height: 20),
          Text(
            'Cześć, witaj z powrotem!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 40),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
              email != null && !EmailValidator.validate(email)
                ? 'Wpisz poprawny email'
                : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Hasło'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
            value != null && value.length < 6
                ? 'Hasło musi zawierać przynajmniej 6 znaków'
                : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: confirmPasswordController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Potiwerdź hasło'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
            value != passwordController.text
                ? 'Hasło nie pasuje!'
                : null,
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.arrow_forward, size: 32),
            label: Text(
              'Zarejestruj się',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: signUp,
          ),
          SizedBox(height: 20),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white, ),
              text: 'Masz konto?  ',
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignIn,
                  text: 'Zaloguj się',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
