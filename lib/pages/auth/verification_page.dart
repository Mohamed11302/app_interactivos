import 'dart:async';
import 'dart:io';

import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/chat/helper/dialogs.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart' as side_menu;
import 'package:app_interactivos/pages/tabbed_window.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_sign_in/google_sign_in.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isEmailVerfied = false;
  Timer? timer; 
  @override
  void initState(){
    super.initState();
    isEmailVerfied = APIs.auth.currentUser!.emailVerified;
    if (!isEmailVerfied){
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }
  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400,
            ],
          ),
        ),
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
                      duration: Duration(milliseconds: 1300),
                      child: Text(
                        "Verify email",
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
                      topRight: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1400),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ],
                          ),

                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: GestureDetector(
                          onTap: () {
                          },
                        child: Text(
                          'Accede a tu correo y verifica tu cuenta',
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                        ),
                      ),
                      SizedBox(height: 50,),
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 300,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Ya tienes una cuenta?"),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await _deleteUser(context);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterLogin()),
                                      (route) => false);
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future checkEmailVerified() async{
    await APIs.auth.currentUser!.reload();
    setState(() {
      isEmailVerfied = APIs.auth.currentUser!.emailVerified;
    });
    if (isEmailVerfied){
      timer?.cancel();
      Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Tabbed_Window()),
                (route) => false);
    }
  }
  Future<void> _deleteUser(BuildContext context) async {
    try {
      //for showing progress dialog
      Dialogs.showProgressBar(context);
      await APIs.firestore.collection('users').doc(APIs.auth.currentUser!.email).delete();
      await APIs.auth.currentUser!.delete();
      //await FirebaseAuth.instance.signOut();
      //await GoogleSignIn().signOut();
    } catch (e) {
      print('+++++++ Error: ${e}');
    }
  }
}
