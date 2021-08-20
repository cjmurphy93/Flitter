import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/services/auth_services.dart';
import 'package:flitter/screens/posts/add_post_screen.dart';
import 'package:flitter/screens/profile/profile.dart';
import 'package:flitter/screens/posts/feed_screen.dart';
import 'package:flitter/screens/search.dart';

class Home extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;
  final List<Widget> _children = [
    FeedScreen(),
    Search(),
  ];

  void onTabPressed(int index) {
    setState(
      () {
        _currentIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Profile.id,
                  arguments: FirebaseAuth.instance.currentUser!.uid,
                );
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabPressed,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            label: 'search',
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
