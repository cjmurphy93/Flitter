import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/models/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/services/post_services.dart';
import 'package:flitter/services/user_services.dart';
import 'package:flitter/screens/posts/post_list.dart';
import 'package:flitter/screens/profile/edit_profile.dart';
import 'package:flitter/models/user.dart';

class Profile extends StatefulWidget {
  static String id = 'profile_screen';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PostService _postService = PostService();
  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<PostModel>?>.value(
          initialData: [],
          // catchError: (_, err) => print(err),
          value: _postService
              .getPostsByUser(FirebaseAuth.instance.currentUser!.uid),
        ),
        StreamProvider<UserModel?>.value(
          // catchError: (_, err) => print(err),
          initialData: UserModel(
            id: '',
            name: '',
            profileImageUrl: '',
            bannerImageUrl: '',
            email: '',
          ),
          value:
              _userService.getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        ),
      ],
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  expandedHeight: 130,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      Provider.of<UserModel?>(context)!.bannerImageUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Text('Your error widget...');
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.network(
                                    Provider.of<UserModel?>(context)!
                                            .profileImageUrl ??
                                        '',
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return Text('Your error widget...');
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, EditProfile.id);
                                    },
                                    child: Text("Edit Profile"),
                                  )
                                ]),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  Provider.of<UserModel?>(context)!.name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: PostsList(),
          ),
        ),
      ),
    );
  }
}
