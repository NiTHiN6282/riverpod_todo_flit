// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_todo_flit/core/constants/firebase_constants.dart';
import 'package:riverpod_todo_flit/core/failure.dart';
import 'package:riverpod_todo_flit/core/globals/globals.dart';
import 'package:riverpod_todo_flit/core/providers/firebase_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/type_defs.dart';
import '../../../models/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    googleSignIn: ref.watch(googleProvider),
    firestore: ref.read(firestoreProvider),
  );
});

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  })  : _googleSignIn = googleSignIn,
        _firestore = firestore;

  FutureEither<String> keepLogin(SharedPreferences prefs) async {
    if (prefs.containsKey('id')) {
      userId = prefs.getString('id')!;
      return right(userId);
    } else {
      userId = "";
      return left(Failure(''));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        return left(Failure("Google Sign In Cancelled!"));
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential? userData =
          await FirebaseAuth.instance.signInWithCredential(credential);

      var newUser = await checkNewUser(userData);

      if (newUser) {
        return right(await createUser(userData));
      } else {
        return right(await getUser(userData));
      }
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<bool> checkNewUser(UserCredential userData) async {
    bool newUser = false;
    var user =
        await _users.where("email", isEqualTo: userData.user!.email).get();

    if (user.docs.isEmpty) {
      newUser = true;
    } else {
      newUser = false;
    }
    return newUser;
  }

  Future<UserModel> createUser(UserCredential userData) async {
    DocumentReference ref = _users.doc();
    UserModel userModel = UserModel(
      name: userData.user?.displayName ?? "",
      email: userData.user?.email ?? "",
      date: DateTime.now(),
      id: ref.id,
    );
    await ref.set(userModel.toMap());
    return userModel;
  }

  Future<UserModel> getUser(UserCredential userData) async {
    var data =
        await _users.where("email", isEqualTo: userData.user!.email).get();

    return UserModel.fromMap(data.docs.first.data() as Map<String, dynamic>);
  }

  logOut(SharedPreferences prefs) async {
    prefs.remove('id');
    await _googleSignIn.signOut();
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);
}
