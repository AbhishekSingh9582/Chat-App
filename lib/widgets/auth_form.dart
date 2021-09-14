import 'dart:io';
import 'package:flutter/material.dart';
import '../picker/image_picker_preview.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(String email, String username, String password,
      File userPickedImage, bool isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _authKey = GlobalKey<FormState>();
  bool hidePass = true;
  var _emailAddress = '';
  var _username = '';
  var _password = '';
  bool _isLogin = true;
  File _pickedImage;

  void _userPickedImage(File image) {
    _pickedImage = image;
  }

  void _trySubmit() {
    final _isValid = _authKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Take a picture'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (_isValid) {
      _authKey.currentState.save();
      widget.submitFn(
        _emailAddress.trim(),
        _username.trim(),
        _password.trim(),
        _pickedImage,
        _isLogin,
        context,
      );
    } else {
      print('not validate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _authKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) ImagePickerPreview(_userPickedImage),
                TextFormField(
                  key: ValueKey('email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter valid email address!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email-address'),
                  onSaved: (value) {
                    _emailAddress = value;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('User Name'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Atleast 4 charaters long username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'User Name'),
                    onSaved: (value) {
                      _username = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Atleast 7 characters long';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: hidePass
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.remove_red_eye_outlined),
                      onPressed: () {
                        setState(() {
                          hidePass = !hidePass;
                        });
                      },
                    ),
                  ),
                  obscureText: hidePass,
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    onPressed: _trySubmit,
                    textColor: Colors.white,
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: _isLogin
                        ? Text('Create New Account')
                        : Text('Already have an account'),
                    textColor: Theme.of(context).primaryColor,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
