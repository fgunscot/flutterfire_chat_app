import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab1_provider_messager/src/authentication/authentication_controller.dart';
import 'package:lab1_provider_messager/src/utils/form_validators.dart';
import 'package:lab1_provider_messager/src/utils/pad_items.dart';
import 'package:lab1_provider_messager/src/utils/button_styles.dart';
import 'package:lab1_provider_messager/src/widgets/dialogs/alert_dialog.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.registerWithPassword,
    required this.updateAuthState,
  }) : super(key: key);

  final void Function(AuthViewStates state) updateAuthState;
  final void Function(String name, String email, String password)
      registerWithPassword;

  static const registerFormSendButtonKey = Key('registerFormSendButton');

  static const registerFormNameTextFieldKey = Key('registerFormNameTextField');
  static const registerFormEmailTextFieldKey =
      Key('registerFormEmailTextField');
  static const registerFormPasswordTextFieldKey =
      Key('registerFormPasswordTextField');
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Register',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          TextFormField(
            key: RegisterForm.registerFormNameTextFieldKey,
            controller: _nameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your Display Name',
            ),
            validator: hasTextValidator(String),
          ),
          TextFormField(
            key: RegisterForm.registerFormEmailTextFieldKey,
            controller: _emailController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your Email',
            ),
            validator: hasTextValidator(String),
          ),
          TextFormField(
            key: RegisterForm.registerFormPasswordTextFieldKey,
            controller: _passwordController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your Password',
            ),
            validator: hasTextValidator(String),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: greyedButton,
                key: AuthenticationView.authCancelButtonKey,
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, 'sign in cancelled!'),
              ),
              ElevatedButton(
                style: acceptButton,
                key: RegisterForm.registerFormSendButtonKey,
                child: const Text('Register'),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    widget.registerWithPassword(_nameController.text,
                        _emailController.text, _passwordController.text);
                  }
                },
              ),
            ],
          ).padTop(14.0),
          Row(
            children: [
              const SizedBox(
                width: 160,
                child: Text('Already have an account?'),
              ),
              TextButton(
                key: AuthenticationView.authSwitchFormsButtonKey,
                child: const Text('Sign in here!'),
                onPressed: () =>
                    widget.updateAuthState(AuthViewStates.signInView),
              ),
            ],
          ).padTop(8.0),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
    required this.signInWithPassword,
    required this.updateAuthState,
  }) : super(key: key);

  final void Function(String email, String password) signInWithPassword;
  final void Function(AuthViewStates state) updateAuthState;

  static const signInFormSendButtonKey = Key('signInFormSendButton');

  static const signInFormEmailTextFieldKey = Key('signInFormEmailTextField');
  static const signInFormPasswordTextFieldKey =
      Key('signInFormPasswordTextField');

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Login',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          TextFormField(
            key: SignInForm.signInFormEmailTextFieldKey,
            controller: _emailController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your Email',
            ),
            validator: hasTextValidator(String),
          ),
          TextFormField(
            key: SignInForm.signInFormPasswordTextFieldKey,
            controller: _passwordController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your Password',
            ),
            validator: hasTextValidator(String),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: greyedButton,
                key: AuthenticationView.authCancelButtonKey,
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, 'sign in cancelled!'),
              ),
              ElevatedButton(
                style: acceptButton,
                key: SignInForm.signInFormSendButtonKey,
                child: const Text('Sign In'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.signInWithPassword(
                        _emailController.text, _passwordController.text);
                  }
                },
              ),
            ],
          ).padTop(14.0),
          Row(
            children: [
              const SizedBox(
                width: 160,
                child: Text('Already have an account?'),
              ),
              TextButton(
                key: AuthenticationView.authSwitchFormsButtonKey,
                child: const Text('Sign in here!'),
                onPressed: () =>
                    widget.updateAuthState(AuthViewStates.registerView),
              ),
            ],
          ).padTop(8.0),
        ],
      ),
    );
  }
}

// class AuthenticationView extends StatefulWidget {
class AuthenticationView extends StatelessWidget {
  static const routeName = '/authentication';
  const AuthenticationView({Key? key}) : super(key: key);

  // button keys
  static const authCancelButtonKey = Key('authCancelButton');
  static const authSwitchFormsButtonKey = Key('authSwitchFormsButton');

  void _showAlertDialog(BuildContext context, FirebaseAuthException exception) {
    showDialog(
        context: context,
        builder: (context) =>
            ShowAlertDialog(e: exception, title: 'Authentication Failed:'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: SizedBox(
          height: double.infinity,
          width: 380,
          child: Consumer<AuthenticationController>(
            builder: (_, controller, __) {
              switch (controller.authState) {
                case AuthViewStates.signInView:
                  return SignInForm(
                      signInWithPassword: (email, password) =>
                          controller.signInWithPassword(email, password,
                              (e) => _showAlertDialog(context, e)),
                      updateAuthState: controller.updateAuthState);
                case AuthViewStates.registerView:
                  return RegisterForm(
                      registerWithPassword: (name, email, password) =>
                          controller.registerWithPassword(name, email, password,
                              (e) => _showAlertDialog(context, e)),
                      updateAuthState: controller.updateAuthState);
                case AuthViewStates.authComplete:
                  return Center(
                      child: IconButton(
                          icon: const Icon(Icons.abc_rounded),
                          onPressed: () => controller.logOutCurrentUser()));
              }
            },
          ),
        ),
      ),
    );
  }
}
