import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flitter/models/post.dart';

class PostService {
  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostModel(
        id: doc.id,
        text: doc['text'] ?? '',
        creator: doc['creator'] ?? '',
        retweet: doc['retweet'] ?? false,
        numLikes: doc['numLikes'] ?? 0,
        numRetweets: doc['numRetweets'] ?? 0,
        originalId: doc['originalId'] ?? null,
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
}
