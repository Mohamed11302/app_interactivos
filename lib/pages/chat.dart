import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/tabbed_window.dart';

class mAPP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHATS'),
      ),
      body: Center(
        child: Text('Contenido de la pestaña de CHATS'),
      ),
    );
  }
}
