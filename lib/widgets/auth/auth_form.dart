import 'dart:io';

import 'package:chat_app_2/widgets/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  void Function(
    String email,
    String username,
    String password,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool _isLoading;

  AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String _userName = '';
  String _userPassword = '';
  String _userEmail = '';
  File? userImageFile;
  void _pickedImage(File image) {
    userImageFile = image;
  }

  void trySubmit() {
    final isValid = _formKey.currentState!.validate();

    //closes keyboard
    FocusScope.of(context).unfocus();
    if (userImageFile == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an Image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      return;
    }
    if (isValid) {
      _formKey.currentState!.save();

      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        userImageFile,
        isLogin,
        context,
      );
      //  Navigator.pushReplacementNamed(context, ChatScreen.roueName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => _userEmail = value ?? '',
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.length < 4) {
                          return 'Enter at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value ?? '';
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.length < 8) {
                        return 'Enter at least 8 characters';
                      }
                      return null;
                    },
                    onSaved: (value) => _userPassword = value ?? '',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget._isLoading) CircularProgressIndicator(),
                  if (!widget._isLoading)
                    ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(isLogin ? 'Login' : 'Signup'),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: trySubmit,
                    ),
                  if (!widget._isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? 'Create new account'
                          : 'Already have an account'),
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
