import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app_interactivos/pages/auth/register_page.dart';
import 'package:app_interactivos/pages/auth/forgot_password.dart';
import 'package:app_interactivos/pages/tabbed_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/helper/dialogs.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({Key? key}) : super(key: key);

  @override
  _RegisterLoginState createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  String user_data = '';
  String password_data = '';
  bool _obscureText = true;
  bool _isLoginWithGoogle = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.orange.shade900,
          Colors.orange.shade800,
          Colors.orange.shade400
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Findal",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1000),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(225, 95, 27, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        user_data = text;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        labelText: "Email or Phone number",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade200))),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (text) {
                                            setState(() {
                                              password_data = text;
                                            });
                                          },
                                          obscureText: _obscureText,
                                          decoration: InputDecoration(
                                            labelText: "Password",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          FadeInUp(
                            duration: Duration(milliseconds: 1000),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage()),
                                      (route) => false);
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1000),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterPage()),
                                    );
                                  },
                                  height: 50,
                                  color: Colors.blue[500],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: FadeInUp(
                                duration: Duration(milliseconds: 1000),
                                child: MaterialButton(
                                  onPressed: () async {
                                    await _signInWithEmail();
                                  },
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: Colors.orange[900],
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: GestureDetector(
                          onTap: () async {
                            _signInWithGoogle();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _isLoginWithGoogle
                                  ? [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ]
                                  : [
                                      Text(
                                        'Login with Google',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 8),
                                      Image.asset('assets/google_logo.png'),
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      log('+++++++ Error: ${e}');
    }
  }

  Future<void> _signInWithEmail() async {
    Dialogs.showProgressBar(context);
    await _signOut(); //MOHA
    try {
      await APIs.auth
          .signInWithEmailAndPassword(
        email: user_data,
        password: password_data,
      )
          .then((user) async {
        _signIn(user);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Some error happend: ${e}'),
        ),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    Dialogs.showProgressBar(context);
    await _signOut(); //MOHA
    _signInWithGoogle_user().then((user) async {
      _signIn(user);
    });
  }

  Future<UserCredential?> _signInWithGoogle_user() async {
    try {
      //await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print("-----");
      log('\n_signInWithGoogle: $e');
      print("-----");
      Dialogs.showSnackbar(context, 'Something Went Wrong');
      return null;
    }
  }

  Future<void> _signIn(UserCredential? user) async {
    //for hiding progress bar
    Navigator.pop(context);
    final us = user;
    if (us != null) {
      log('\nUser: ${us.user}');
      log('\nUserAdditionalInfo: ${us.additionalUserInfo}');

      if ((await APIs.userExists(us.user!.email!))) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Example()));
      } else {
        final create_user = us.user;
        if (create_user != null) {
          await APIs.createUser(
                  create_user.uid,
                  create_user.displayName.toString(),
                  create_user.email.toString(),
                  create_user.photoURL.toString())
              .then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Example()));
          });
        }
      }
    } else {
      // Las credenciales no son válidas, puedes mostrar un mensaje al usuario.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Credenciales incorrectas'),
            content: Text(
                'El usuario o la contraseña no son válidos. Por favor, inténtelo de nuevo.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
