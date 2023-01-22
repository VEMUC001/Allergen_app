import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

import '../main.dart';
import '../pages/forgot_password_page.dart';
import '../utils.dart';


class LoginWidget extends StatefulWidget {
  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void disponse() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
   padding: EdgeInsets.all(16),
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       SizedBox(height: 60),
       Text(
         'Allergen Scanner',
         textAlign: TextAlign.center,
         style: TextStyle(fontSize: 35, fontWeight: FontWeight.normal),
       ),
       SizedBox(height: 35),
       Image.asset('assets/images/barcode-scanner.png'),
       SizedBox(height: 20),
       // Text(
       //   'Witaj!',
       //   textAlign: TextAlign.center,
       //   style: TextStyle(fontSize: 35, fontWeight: FontWeight.normal),
       // ),
       //SizedBox(height: 20),
       TextField(
         controller: emailController,
         cursorColor: Colors.white,
         textInputAction: TextInputAction.next,
         decoration: InputDecoration(labelText: 'Email'),
       ),
       SizedBox(height: 4),
       TextField(
         controller: passwordController,
         textInputAction: TextInputAction.done,
         decoration: InputDecoration(labelText: 'Hasło'),
         obscureText: true,
       ),
       SizedBox(height: 20),
       ElevatedButton.icon(
         style: ElevatedButton.styleFrom(
           minimumSize: Size.fromHeight(50),
         ),
         icon: Icon(Icons.lock_open, size: 32),
         label: Text(
           'Zaloguj się',
           style: TextStyle(fontSize: 24),
         ),
         onPressed: signIn,
       ),
       SizedBox(height: 24),
       GestureDetector(
         child: Text(
           'Zapomniałeś hasła?',
           style: TextStyle(
             decoration: TextDecoration.underline,
             color: Theme.of(context).colorScheme.secondaryContainer,
             fontSize: 20,
           ),
         ),
         onTap: () => Navigator.of(context).push(MaterialPageRoute(
           builder: (context) => ForgotPasswordPage(),
         )),
       ),
       SizedBox(height: 16),
       RichText(
         text: TextSpan(
             style: TextStyle(color: Colors.white, ),
           text: 'Nie masz konta?  ',
           children: [
             TextSpan(
               recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
               text: 'Zarejestruj się',
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
  );

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
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
