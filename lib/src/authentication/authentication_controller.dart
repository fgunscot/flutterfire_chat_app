import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_service.dart';

enum AuthViewStates { authComplete, signInView, registerView }

class AuthenticationController with ChangeNotifier {
  AuthenticationController(this.authService) {
    authService.controller = this;
  }

  AuthViewStates _authState = AuthViewStates.signInView;
  AuthViewStates get authState => _authState;
  void updateAuthState(AuthViewStates state) {
    _authState = state;
    notifyListeners();
  }

  final AuthenticationService authService;

  void signInWithPassword(String email, String password,
      void Function(FirebaseAuthException e) errorCallback) {
    var model = AuthenticationModel(email: email, password: password);
    authService.signInWithPassword(
      model,
      (e) => errorCallback(e),
    );
  }

  void registerWithPassword(String name, String email, String password,
      void Function(FirebaseAuthException e) errorCallback) {
    var model = AuthenticationModel(
        displayName: name, email: email, password: password);
    authService.registerWithPassword(
      model,
      (e) => errorCallback(e),
    );
  }

  void logOutCurrentUser() => authService.logOutCurrentUser();

  void onUserModelChanged(bool model) {
    if (model) {
      _authState = AuthViewStates.authComplete;
    } else {
      _authState = AuthViewStates.signInView;
    }
    notifyListeners();
  }
}
