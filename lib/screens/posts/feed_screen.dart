import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/services/post_services.dart';
import 'package:flitter/screens/posts/post_list.dart';
import 'package:flitter/models/post.dart';

class FeedScreen extends StatefulWidget {
  static String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<PostModel>?>.value(
      initialData: [],
      value: _postService.getFeed(),
      child: Scaffold(
        body: PostsList(null),
      ),
    );
  }
}
