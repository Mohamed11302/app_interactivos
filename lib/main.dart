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
      home: RegisterLogin(),
    );
  }
}
