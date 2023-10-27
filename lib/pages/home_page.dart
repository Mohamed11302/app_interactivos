import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //const MenuPage({super.key});
  final String user;
  final String password;
  HomePage({required this.user, required this.password});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MENU'),
      ),
      body: Center(
        child: Text('Usuario: ${widget.user}\nPassword: ${widget.password}'),       
      ),
      
    );
  }
}