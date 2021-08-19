import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/services/post_services.dart';
import 'package:flitter/screens/posts/post_list.dart';

class Profile extends StatefulWidget {
  static String id = 'profile_screen';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      initialData: null,
      value:
          _postService.getPostsByUser(FirebaseAuth.instance.currentUser!.uid),
      child: Scaffold(
        body: Container(
          child: PostsList(),
        ),
      ),
      // create: (context) {
      //   return Scaffold(
      //       body: Container(
      //           child: PostsList(),
      //         )
      //   );
      // }
    );
  }
}
