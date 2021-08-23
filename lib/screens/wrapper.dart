import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/screens/home.dart';
import 'package:flitter/screens/welcome_screen.dart';
import 'package:flitter/screens/auth/registration_screen.dart';
import 'package:flitter/screens/auth/login_screen.dart';
import 'package:flitter/screens/posts/feed_screen.dart';
import 'package:flitter/screens/posts/add_post_screen.dart';
import 'package:flitter/screens/profile/profile.dart';
import 'package:flitter/screens/profile/edit_profile.dart';
import 'package:flitter/screens/posts/replies.dart';
import 'package:flitter/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    print(user);
    if (user == null) {
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

    return MaterialApp(
      title: 'Flitter',
      home: Home(),
      initialRoute: Home.id,
      routes: {
        FeedScreen.id: (context) => FeedScreen(),
        AddPost.id: (context) => AddPost(),
        Profile.id: (context) => Profile(),
        EditProfile.id: (context) => EditProfile(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        Replies.id: (context) => Replies(),
      },
    );
  }
}
