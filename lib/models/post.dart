import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String? creator;
  final String? text;
  final Timestamp? timestamp;
  final bool? retweet;
  final String? originalId;
  DocumentReference? ref;
  int? numLikes;
  int? numRetweets;

  PostModel({
     this.id,
     this.creator,
     this.text,
     this.timestamp,
     this.retweet,
     this.numLikes,
     this.numRetweets,
    this.originalId,
    this.ref,
  });
}
