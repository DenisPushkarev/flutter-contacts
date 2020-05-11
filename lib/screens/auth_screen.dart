import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void _onLogin(String email, String password, bool _isRegistration, BuildContext ctx) async {
    AuthResult ar;
    try {
      setState(() {
        isLoading = true;
      });
      if (_isRegistration) {
        ar = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await Firestore.instance.collection('users').document(ar.user.uid).setData({
          'uid': ar.user.uid,
          'email': email,
        });
      } else {
        ar = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
    } on PlatformException catch (err) {
      setState(() {
        isLoading = false;
      });

      var message = err.message ?? 'Ошибка входа';
      if (err.code == "ERROR_USER_NOT_FOUND") message = "Пользователь не зарегистрирован";
      if (err.code == "ERROR_WRONG_PASSWORD") message = "Неверный пароль";
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).errorColor,
          content: Text(message),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_onLogin, isLoading),
    );
  }
}
