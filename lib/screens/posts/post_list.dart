import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/models/post.dart';

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    // final posts = Provider.of<List<PostModel>>(context);
    final posts = Provider.of<List<PostModel>?>(context) ?? [];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          title: Text(post.creator),
          subtitle: Text(post.text),
        );
      },
    );
  }
}
