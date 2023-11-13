import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: MyAppBarDrawer(),
      drawer: NavBar(),
      body: Center(
        child: Text('Pestaña Settings'),
      ),
    );
  }
}
