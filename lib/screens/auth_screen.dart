import 'dart:io';
import 'package:flutter/services%20(2).dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitAuthForm(String email, String username, String password,
      File userPickedImage, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.png');
        await ref.putFile(userPickedImage);
        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('user')
            .doc(authResult.user.uid)
            .set({
          'user': username,
          'email': email,
          'userImage': url,
        });
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
      }
    } on PlatformException catch (error) {
      var message = "Couldn't authenticate. Please check your credentials!";
      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
