import 'package:flutter/material.dart';

class FeedScreen extends StatefulWidget {
  static String id = 'feed_screen';

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Text('feed');
  }
}
