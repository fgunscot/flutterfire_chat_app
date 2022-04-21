import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
import 'package:lab1_provider_messager/src/messager/messager_service.dart';

class AuthenticationService {
  AuthenticationService() {
    init();
  }

  AuthenticationController? controller;

  final _usersCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        controller!.onUserModelChanged(true);
      } else {
        controller!.onUserModelChanged(false);
      }
    });
  }

  Future<void> signInWithPassword(
    AuthenticationModel model,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: model.email, password: model.password);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> registerWithPassword(
    AuthenticationModel model,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email, password: model.password);
      await credential.user!.updateDisplayName(model.displayName);
      await addUser(credential.user!.uid, model.displayName!);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> addUser(String id, String name) async {
    await _usersCollectionRef.doc(id).set(UserModel(
          displayName: name,
          chatIds: {},
        ));
  }

  void logOutCurrentUser() async {
    FirebaseAuth.instance.signOut();
  }
}

class AuthenticationModel {
  AuthenticationModel({
    this.displayName,
    required this.email,
    required this.password,
  });
  String? displayName;
  String email;
  String password;
}
