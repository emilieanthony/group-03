// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';

import 'bottomnavbar.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;



/// Entrypoint example for registering via Email/Password.
class RegisterPage extends StatefulWidget {
  final FirebaseApp app;
  /// The page title.
  final String title = 'Registration';

  RegisterPage(this.app);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool registration = false;
  bool checkBoxValue = false;
  //String _userEmail = '';


  @override
  Widget build(BuildContext context) {
    _usernameController.addListener(() {print(_usernameController.text);});

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      labelText: "Name",
                      ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(
                    ),
                      labelText: "Email",
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                      ),
                      labelText: "Password",
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  Container(
                    child: Row (
                      children: <Widget> [
                      Checkbox(
                          value: checkBoxValue,
                          onChanged: (bool value) {
                            setState(() {
                              checkBoxValue = value;
                            });
                          },
                      ),
                        Text("I agree to terms and conditions")
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    child: SignInButtonBuilder(
                      icon: Icons.person_add,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      fontSize: 18,
                      backgroundColor: Colors.green.shade300,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            registration = true;
                          });
                        }
                      },
                      text: 'Register',
                    ),
                  ),
                  registration ? FutureBuilder(
                      future: _register(),
                      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (BuildContext context) => BottomBar(widget.app)));
                            // Navigator.of(context).push(MaterialPageRoute(builder: (_) => ));
                          });

                          return Container(
                            alignment: Alignment.center,
                            child: Text(snapshot.hasData ? 'Successfully registered ${snapshot.data.displayName}' : 'Registration failed'),
                          );
                        }
                        return Center(child: CircularProgressIndicator(),);
                        // : 'Registration failed')),
                      }
                  ) : Container(),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Example code for registration.
  Future<User> _register() async {
    User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      await user.updateProfile(displayName: _usernameController.text);
      user = _auth.currentUser;
    }

    print(user.toString());
    return user;
    //   final User user = (await _auth.createUserWithEmailAndPassword(
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //   )).user;
    //   if (user != null) {
    //     await user.updateProfile(displayName: _usernameController.text);
    //
    //     // print('${user.displayName}');
    //     setState(() {
    //       _success = true;
    //       _userEmail = user.displayName;
    //     });
    //
    //   } else {
    //     _success = false;
    //   }
  }
}

