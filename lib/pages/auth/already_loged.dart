import 'dart:developer';
import 'dart:io';

import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app_interactivos/pages/auth/register_page.dart';
import 'package:app_interactivos/pages/auth/forgot_password.dart';
import 'package:app_interactivos/pages/tabbed_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/chat/helper/dialogs.dart';

//splash screen
class AlreadyLogedScreen extends StatefulWidget {
  const AlreadyLogedScreen({super.key});

  @override
  State<AlreadyLogedScreen> createState() => _AlreadyLogedScreenState();
}

class _AlreadyLogedScreenState extends State<AlreadyLogedScreen> {
  @override
  void initState() {
    super.initState();
    if (APIs.auth.currentUser != null) {
      log('\nUser: ${APIs.auth.currentUser}');
      //navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Tabbed_Window()));
    } else {
      //navigate to login screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => RegisterLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
