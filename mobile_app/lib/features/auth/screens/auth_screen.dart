import 'package:flutter/material.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

/// Auth screen wrapper that toggles between Sign In and Sign Up
class AuthScreen extends StatefulWidget {
  final VoidCallback onAuthSuccess;

  const AuthScreen({
    Key? key,
    required this.onAuthSuccess,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showSignIn = true;

  void _toggleAuthMode() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showSignIn
        ? SignInScreen(
            onSignUpPressed: _toggleAuthMode,
            onSuccess: widget.onAuthSuccess,
          )
        : SignUpScreen(
            onSignInPressed: _toggleAuthMode,
            onSuccess: widget.onAuthSuccess,
          );
  }
}
