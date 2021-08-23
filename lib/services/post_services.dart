import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/models/post.dart';
import 'package:flitter/services/user_services.dart';
import 'package:quiver/iterables.dart';

class PostService {
  List<PostModel> _postListFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc.data()['text'] ?? '',
        creator: doc.data()['creator'] ?? '',
        retweet: doc.data()['retweet'] ?? false,
        numLikes: doc.data()['numLikes'] ?? 0,
        numRetweets: doc.data()['numRetweets'] ?? 0,
        originalId: doc.data()['originalId'] ?? null,
        timestamp: doc.data()['timestamp'] ?? 0 as Timestamp?,
        ref: doc.reference,
      );
    }).toList();
  }

  PostModel? _postFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.exists
        ? PostModel(
            id: snapshot.id,
            text: snapshot['text'] ?? '',
            creator: snapshot['creator'] ?? '',
            retweet: snapshot['retweet'] ?? false,
            numLikes: snapshot.data()!['numLikes'] ?? 0,
            numRetweets: snapshot.data()!['numRetweets'] ?? 0,
            originalId: snapshot.data()!['originalId'] ?? null,
            timestamp: snapshot['timestamp'] ?? 0 as Timestamp?,
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

  Future<List<PostModel>?> getReplies(PostModel post) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await post.ref!
        .collection("replies")
        .orderBy('timestamp', descending: true)
        .get();

    return _postListFromSnapshot(querySnapshot);
  }


  Stream<List<PostModel>?> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where('creator', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }


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

      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }

    feedList.sort((a, b) {
      var aDate = a.timestamp!;
      var bDate = b.timestamp!;
      return bDate.compareTo(aDate);
    });

    return feedList;
  }

  Future likePost(PostModel post, bool current) async {
    if (current) {
      post.numLikes = post.numLikes! - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();
    }
    if (!current) {
      post.numLikes = post.numLikes! + 1;

      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({});
    }
  }

  Stream<bool> getCurrentUserLike(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("likes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.exists;
      },
    );
  }

  Future retweet(PostModel post, bool current) async {
    if (current) {
      post.numRetweets = post.numRetweets! - 1;
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.id)
          .collection("retweets")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection("posts")
          .where("originalId", isEqualTo: post.id,)
          .where("creator", isEqualTo: FirebaseAuth.instance.currentUser!.uid,)
          .get()
          .then(
        (value) {
          if (value.docs.length == 0) {
            return;
          }
          FirebaseFirestore.instance
              .collection("posts")
              .doc(value.docs[0].id)
              .delete();
        },
      );
      return;
    }
    post.numRetweets = post.numRetweets! + 1;
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    await FirebaseFirestore.instance.collection("posts").add(
      {
        'creator': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'retweet': true,
        'originalId': post.id
      },
    );
  }

  Stream<bool> getCurrentUserRetweet(PostModel post) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(post.id)
        .collection("retweets")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) {

      return snapshot.exists;
    });
  }

  Future<PostModel?> getPostById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> postSnap =
    await FirebaseFirestore.instance.collection("posts").doc(id).get();

    return _postFromSnapshot(postSnap);
  }
}
