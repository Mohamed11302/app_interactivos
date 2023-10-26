import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  //const MenuPage({super.key});
  final String user;
  final String password;
  MenuPage({required this.user, required this.password});
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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