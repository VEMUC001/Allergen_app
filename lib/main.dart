import 'package:flutter/material.dart';
import 'package:food_allergen_app/pages/auth_page.dart';
import 'package:food_allergen_app/pages/home_page.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_allergen_app/pages/user_allergens_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_allergen_app/pages/verify_email_page.dart';
import 'package:food_allergen_app/widgets/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';

// void main() {
//   runApp(const MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final String title = 'Flutter Food Allergen App';

  @override
  Widget build(BuildContext context) => MaterialApp(
    scaffoldMessengerKey: Utils.messengerKey,
    navigatorKey: navigatorKey,
    debugShowCheckedModeBanner: false,
    title: title,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: MainPage(),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Coś poszło nie tak'));
        } else if (snapshot.hasData) {
          return VerifyEmailPage();
        } else {
          return AuthPage();
        }
      },
    ),
  );
}



