import 'package:flitter/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null
        ? UserModel(
            id: user.uid,
            email: user.email,
          )
        : null;
  }

  Stream<UserModel?> get user {
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signUp(email, password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .set({
        'name': email,
        'email': email,
      });
      _userFromFirebaseUser(user.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('An account already exists for that email');
      } else if (e.code == 'weak-password') {
        print('Please use a stronger password');
      }
    } catch (e) {
      print(e);
    }
  }
}
