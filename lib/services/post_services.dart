import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/models/post.dart';

class PostService {
  // List<PostModel>? _postListFromSnapshot(QuerySnapshot snapshot) {
  //   // print(snapshot.docs);
  //   return snapshot.docs.map((doc) {
  //     return PostModel(
  //       id: doc.id,
  //       text: doc['text'] ?? '',
  //       creator: doc['creator'] ?? '',
  //       retweet: doc['retweet'] ?? false,
  //       numLikes: doc['numLikes'] ?? 0,
  //       numRetweets: doc['numRetweets'] ?? 0,
  //       originalId: doc['originalId'] ?? null,
  //       timestamp: doc['timestamp'] ?? 0,
  //       ref: doc.reference,
  //     );
  //   }).toList();
  // }

  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    print(snapshot.docs[0].reference);
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc.get('text') ?? '',
        creator: doc.get('creator') ?? '',
        retweet: doc.get('retweet') ?? false,
        numLikes: doc.get('numLikes') ?? 0,
        numRetweets: doc.get('numRetweets') ?? 0,
        originalId: doc.get('originalId') ?? null,
        timestamp: doc.get('timestamp') ?? 0,
        // ref: doc.reference,
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

  Stream<List<PostModel>> getPostsByUser(uid) {
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

}
