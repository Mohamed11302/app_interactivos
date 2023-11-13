import 'dart:developer';

import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/tabbed_window.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:firebase_core/firebase_core.dart';

late Size mq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Already_Loged() ? Tabbed_Window() : RegisterLogin(),
    );
  }
}

bool Already_Loged() {
  bool AlreadyLoged;
  if (APIs.auth.currentUser != null) {
    log('\nUser: ${APIs.auth.currentUser}');
    AlreadyLoged = true;
  } else {
    AlreadyLoged = false;
  }
  return AlreadyLoged;
}
