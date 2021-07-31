import 'package:flitter/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User user) {
    return user != null
        ? UserModel(
            id: user.uid,
            email: user.email,
          )
        : null;
  }
}
