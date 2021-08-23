import 'package:flutter/material.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/models/user.dart';
import 'package:flitter/services/post_services.dart';
import 'package:flitter/screens/posts/replies.dart';

class PostItem extends StatefulWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel?> snapshotUser;
  final AsyncSnapshot<bool> snapshotLike;
  final AsyncSnapshot<bool> snapshotRetweet;
  final bool retweet;

  PostItem(this.post, this.snapshotUser, this.snapshotLike,
      this.snapshotRetweet, this.retweet,
      {Key? key})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Padding(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.snapshotRetweet.data! || widget.retweet) Text("Retweet"),
            SizedBox(height: 20),
            Row(
              children: [
                widget.snapshotUser.data!.profileImageUrl != ''
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.snapshotUser.data!.profileImageUrl!,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                      ),
                SizedBox(width: 10),
                Text(widget.snapshotUser.data!.name!)
              ],
            ),
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
                Text(widget.post.text!),
                SizedBox(height: 20),
                Text(widget.post.timestamp!.toDate().toString()),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: new Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            Replies.id,
                            arguments: widget.post,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: new Icon(
                            widget.snapshotRetweet.data!
                                ? Icons.cancel
                                : Icons.repeat,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          onPressed: () => _postService.retweet(
                            widget.post,
                            widget.snapshotRetweet.data!,
                          ),
                        ),
                        Text(widget.post.numRetweets.toString())
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: new Icon(
                            widget.snapshotLike.data!
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          onPressed: () {
                            _postService.likePost(
                              widget.post,
                              widget.snapshotLike.data!,
                            );
                          },
                        ),
                        Text(widget.post.numLikes.toString())
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
