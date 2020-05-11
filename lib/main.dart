import 'package:contacts/screens/auth_screen.dart';
import 'package:contacts/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Бизнес-контакты',
      theme: ThemeData(
          primarySwatch: Colors.green,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.green,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          )),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return MainScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
