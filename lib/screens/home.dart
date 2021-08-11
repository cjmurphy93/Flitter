import 'package:flitter/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/auth_services.dart';
import 'package:flitter/screens/add_post_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          RoundedButton(
            title: "Sign Out",
            onPressed: () async {
              _authService.signOut();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddPost.id);
          },
          child: Icon(Icons.add)),
    );
  }
}
