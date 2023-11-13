import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/app_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: MyAppBarDrawer(),
      drawer: NavigDrawer(),
      body: Center(
        child: Text('Pestaña Acerca De'),
      ),
    );
  }
}
