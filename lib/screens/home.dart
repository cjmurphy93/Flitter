import 'package:flitter/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/auth_services.dart';
import 'package:flitter/screens/posts/add_post_screen.dart';

class Home extends StatelessWidget {
  static String id = 'home_screen';
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        // actions: <Widget>[
        //   RoundedButton(
        //     title: "Sign Out",
        //     onPressed: () async {
        //       _authService.signOut();
        //     },
        //   )
        // ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddPost.id);
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('drawer header'),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () async {
                _authService.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
