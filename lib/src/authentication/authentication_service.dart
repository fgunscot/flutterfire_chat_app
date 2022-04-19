import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';

class AuthenticationService {
  AuthenticationService() {
    init();
  }

  AuthenticationController? controller;

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
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
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
