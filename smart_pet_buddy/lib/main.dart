// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

//import 'package:firebase_auth/firebase_auth.dart'; // Only needed if you configure the Auth Emulator below
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import './register_page.dart';
import './signin_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(AuthExampleApp(app));
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class AuthExampleApp extends StatelessWidget {
  final FirebaseApp app;

  AuthExampleApp(this.app);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Pet Buddy',
      theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.grey[400],
          textTheme: TextTheme(
              headline3: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 45.0,
                color: Colors.orange,
              ))),
      home: Scaffold(
        body: AuthTypeSelector(app),
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
class AuthTypeSelector extends StatelessWidget {
  final FirebaseApp app;

  AuthTypeSelector(this.app); // Navigates to a new page

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pet Buddy'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: <Widget>[
          SizedBox(
              child: Column( children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Image.asset('images/header1.png', scale: 1.1, ),

                )
              ])),
          SizedBox(
            child: Column( children: <Widget>[
              Padding(
             padding: EdgeInsets.all(5),
              child: Image.asset('images/c3d3a8af0c4b499b952695ea3942a889.png',),
            )
           ])),

          Container(
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            //backgroundColor: Colors.indigo,
            // child: ElevatedButton(
            //   child: Text("Registration"),
            //   onPressed: () => _pushPage(context, RegisterPage()),
            // )

            child: SignInButtonBuilder(
              padding: const EdgeInsets.all(13),
              icon: Icons.person_add,
              //backgroundColor: Colors.indigo,
              backgroundColor: Color(0xFF6BC68D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              text: 'Registration',
              onPressed: () => _pushPage(context, RegisterPage(app)),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            // child: ElevatedButton(
            //   child: Text("Registration"),
            //   onPressed: () => _pushPage(context, SignInPage()),
            // )

            child: SignInButtonBuilder(
              padding: const EdgeInsets.all(13),
              icon: Icons.verified_user,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              backgroundColor: Color(0xFF6BC68D),
              text: 'Sign In',
              onPressed: () => _pushPage(context, SignInPage(app)),
            ),
          ),
          SizedBox(width: 40),
          Container (
          child: Column( children: <Widget>[
          Padding(
          padding: EdgeInsets.only(left: 0, top: 131.5, right: 0, bottom: 0,),
          child: Image.asset('images/footer.png', scale: 0.3),

          )
          ])),
        ],
      ),
    );
  }
}
