import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/screens/posts/post_list.dart';
import 'package:flitter/services/post_services.dart';

class Replies extends StatefulWidget {
  static String id = 'replies';
  Replies({Key? key}) : super(key: key);

  @override
  _RepliesState createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  PostService _postService = PostService();
  String text = '';
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PostModel args = ModalRoute.of(context)!.settings.arguments as PostModel;
    return FutureProvider<List<PostModel>?>.value(
      initialData: [],
      value: _postService.getReplies(args),
      child: Container(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                Expanded(
                  child: PostsList(args),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Form(
                        child: TextFormField(
                          controller: _textController,
                          onChanged: (val) {
                            setState(
                              () {
                                text = val;
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          await _postService.reply(args, text);
                          _textController.text = '';
                          setState(
                            () {
                              text = '';
                            },
                          );
                        },
                        child: Text("Reply"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
