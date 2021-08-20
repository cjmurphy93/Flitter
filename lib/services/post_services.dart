import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/services/user_services.dart';
import 'package:quiver/iterables.dart';

class PostService {
  List<PostModel>? _postListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc.get('text') ?? '',
        creator: doc.get('creator') ?? '',
        retweet: doc.get('retweet') ?? false,
        numLikes: doc.data()['numLikes'] ?? 0,
        numRetweets: doc.data()['numRetweets'] ?? 0,
        originalId: doc.data()['originalId'] ?? null,
        timestamp: doc['timestamp'] ?? 0,
        ref: doc.reference,
      );
    }).toList();
  }

  PostModel? _postFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.exists
        ? PostModel(
            id: snapshot.id,
            text: snapshot['text'] ?? '',
            creator: snapshot['creator'] ?? '',
            retweet: snapshot['retweet'] ?? false,
            numLikes: snapshot['numLikes'] ?? 0,
            numRetweets: snapshot['numRetweets'] ?? 0,
            originalId: snapshot['originalId'] ?? null,
            timestamp: snapshot['timestamp'] ?? 0,
            ref: snapshot.reference,
          )
        : null;
  }

  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add(
      {
        'text': text,
        'creator': FirebaseAuth.instance.currentUser!.uid,
        'retweet': false,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  Future reply(PostModel post, String text) async {
    if (text == '') {
      return;
    }

    await post.ref!.collection("replies").add(
      {
        'text': text,
        'creator': FirebaseAuth.instance.currentUser!.uid,
        'retweet': false,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
  }

  Stream<List<PostModel>?> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  // Stream<QuerySnapshot<Map<String, dynamic>>> getPostsByUser(uid) {
  //   return FirebaseFirestore.instance
  //       .collection("posts")
  //       .where('creator', isEqualTo: uid)
  //       .snapshots();
  //       // .map(_postListFromSnapshot);
  // }

  Future<List<PostModel>?> getFeed() async {
    List<String> usersFollowing = await UserService()
        .getUserFollowing(FirebaseAuth.instance.currentUser!.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
    inspect(splitUsersFollowing);

    List<PostModel>? feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('creator', whereIn: splitUsersFollowing.elementAt(i))
              .orderBy('timestamp', descending: true)
              .get();

      feedList.addAll(_postListFromSnapshot(querySnapshot)!);
    }

    feedList.sort((a, b) {
      var aDate = a.timestamp;
      var bDate = b.timestamp;
      return bDate.compareTo(aDate);
    });

    return feedList;
  }
}
