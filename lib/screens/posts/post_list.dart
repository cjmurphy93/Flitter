import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/models/user.dart';
import 'package:flitter/services/user_services.dart';
import 'package:flitter/services/post_services.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  UserService _userService = UserService();
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    // final posts = Provider.of<List<PostModel>>(context);
    final posts = Provider.of<List<PostModel>?>(context) ?? [];
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return StreamBuilder(
          stream: _userService.getUserInfo(post.creator),
          builder:
              (BuildContext context, AsyncSnapshot<UserModel?> userSnapshot) {
            if (!userSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return StreamBuilder(
              stream: _postService.getCurrentUserLike(post),
              builder:
                  (BuildContext context, AsyncSnapshot<bool> likeSnapshot) {
                if (!likeSnapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListTile(
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Row(
                      children: [
                        userSnapshot.data!.profileImageUrl != ''
                            ? CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  // '${userSnapshot.data!.profileImageUrl}'),
                                  userSnapshot.data!.profileImageUrl.toString(),
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 40,
                              ),
                        SizedBox(width: 10),
                        // Text('${userSnapshot.data!.name}')
                        Text(userSnapshot.data!.name.toString())
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.text),
                            SizedBox(height: 20),
                            Text(post.timestamp.toDate().toString()),
                            SizedBox(height: 20),
                            IconButton(
                              icon: new Icon(
                                likeSnapshot.data!
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              onPressed: () {
                                _postService.likePost(post, likeSnapshot.data!);
                              },
                            ),
                            Text(post.numLikes.toString())
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
