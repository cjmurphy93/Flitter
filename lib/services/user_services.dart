import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flitter/models/user.dart';

import 'package:flitter/services/utils.dart';

class UserService {
  UtilsService _utilsService = UtilsService();

  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? UserModel(
            id: snapshot.id,
            name: snapshot['name'],
            profileImageUrl: snapshot['profileImageUrl'],
            bannerImageUrl: snapshot['bannerImageUrl'],
            email: snapshot['email'],
          )
        : null;
  }

  Stream<UserModel?> getUserInfo(uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }

  Future<void> updateProfile(
      File? _bannerImage, File? _profileImage, String name) async {
    String bannerImageUrl = '';
    String profileImageUrl = '';

    if (_bannerImage != null) {
      bannerImageUrl = await _utilsService.uploadFile(_bannerImage,
          'user/profile/${FirebaseAuth.instance.currentUser!.uid}/banner');
    }
    if (_profileImage != null) {
      profileImageUrl = await _utilsService.uploadFile(_profileImage,
          'user/profile/${FirebaseAuth.instance.currentUser!.uid}/profile');
    }

    Map<String, Object> data = new HashMap();
    if (name != '') data['name'] = name;
    if (bannerImageUrl != '') data['bannerImageUrl'] = bannerImageUrl;
    if (profileImageUrl != '') data['profileImageUrl'] = profileImageUrl;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }
}