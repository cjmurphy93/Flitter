import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flitter/screens/welcome_screen.dart';
import 'package:flitter/screens/auth/registration_screen.dart';
import 'package:flitter/screens/auth/login_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Flitter());
}

class Flitter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flitter',
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
      },
    );
  }
}
