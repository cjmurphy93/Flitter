import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flitter/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flitter/services/auth_services.dart';
import 'package:flitter/screens/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Flitter());
}

class Flitter extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {}

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserModel?>.value(
            value: AuthService().user,
            initialData: null,
            child: MaterialApp(
              home: Wrapper(),
            ),
          );
        }

        return Text(
          "Loading",
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
