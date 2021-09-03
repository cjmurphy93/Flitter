import 'package:flutter/material.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/models/user.dart';
import 'package:flitter/services/post_services.dart';
import 'package:flitter/services/user_services.dart';
import 'package:flitter/screens/posts/replies.dart';
import 'package:flitter/services/utils.dart';

class PostItem extends StatefulWidget {
  final PostModel post;
  final AsyncSnapshot<UserModel?> snapshotUser;
  final AsyncSnapshot<bool> snapshotLike;
  final AsyncSnapshot<bool> snapshotRetweet;
  final bool retweet;
  final String? retweetUser;

  PostItem(this.post, this.snapshotUser, this.snapshotLike,
      this.snapshotRetweet, this.retweet, this.retweetUser,
      {Key? key})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  PostService _postService = PostService();
  UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (widget.snapshotRetweet.data! || widget.retweet) Text("${widget.retweetUser} Retweet"),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: widget.snapshotUser.data!.profileImageUrl != ''
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
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5.0),
                          child: Text(
                            widget.snapshotUser.data!.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '@${widget.snapshotUser.data!.name!} · ${UtilsService.timeAgoSinceDate(widget.post.timestamp!.toDate().toString())}',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 14.0,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Text(
                      widget.post.text!,
                      overflow: TextOverflow.clip,
                    ),

                    Container(
                      margin: const EdgeInsets.only(top: 10.0, right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: new Icon(
                                  Icons.chat_bubble_outline,
                                  size: 16.0,
                                  color: Colors.black45,
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
                                  size: 16.0,
                                  color: Colors.black45,
                                ),
                                onPressed: () => _postService.retweet(
                                  widget.post,
                                  widget.snapshotRetweet.data!,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(6.0),
                                child: Text(
                                  widget.post.numRetweets.toString(),
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: new Icon(
                                  widget.snapshotLike.data!
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: widget.snapshotLike.data!
                                      ? Colors.blue
                                      : Colors.black45,
                                  size: 16.0,
                                ),
                                onPressed: () {
                                  _postService.likePost(
                                    widget.post,
                                    widget.snapshotLike.data!,
                                  );
                                },
                              ),
                              Container(
                                margin: const EdgeInsets.all(6.0),
                                child: Text(
                                  widget.post.numLikes.toString(),
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.share,
                                size: 16.0,
                                color: Colors.black45,
                              ),
                              Container(
                                margin: const EdgeInsets.all(6.0),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
