import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/models/user.dart';
import 'package:flitter/screens/posts/post_item.dart';
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
        if (post.retweet) {
          return FutureBuilder(
            future: _postService.getPostById(post.originalId.toString()),
            builder: (
              BuildContext context,
              AsyncSnapshot<PostModel?> snapshotPost,
            ) {
              if (!snapshotPost.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return mainPost(
                snapshotPost.data!,
                true,
              );
            },
          );
        }
        return mainPost(
          post,
          false,
        );
      },
    );
  }

  StreamBuilder<UserModel?> mainPost(PostModel post, bool retweet) {
    return StreamBuilder(
      stream: _userService.getUserInfo(post.creator),
      builder: (
        BuildContext context,
        AsyncSnapshot<UserModel?> snapshotUser,
      ) {
        if (!snapshotUser.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }


        return StreamBuilder(
          stream: _postService.getCurrentUserLike(post),
          builder: (
            BuildContext context,
            AsyncSnapshot<bool> snapshotLike,
          ) {
            if (!snapshotLike.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return StreamBuilder(
              stream: _postService.getCurrentUserRetweet(post),
              builder: (
                BuildContext context,
                AsyncSnapshot<bool> snapshotRetweet,
              ) {
                if (!snapshotLike.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return PostItem(
                  post,
                  snapshotUser,
                  snapshotLike,
                  snapshotRetweet,
                  retweet,
                );
              },
            );
          },
        );
      },
    );
  }
}
