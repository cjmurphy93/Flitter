import 'package:flutter/material.dart';
import 'package:flitter/services/post_services.dart';
import 'package:flitter/components/rounded_button.dart';

class AddPost extends StatefulWidget {
  static String id = 'add_post_screen';

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final PostService _postService = PostService();
  String text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweet'),
        actions: <Widget>[
          RoundedButton(
            title: "Tweet",
            onPressed: () async {
              _postService.savePost(text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: new Form(
          child: TextFormField(
            onChanged: (val) {
              setState(() {
                text = val;
              });
            },
          ),
        ),
      ),
    );
  }
}
