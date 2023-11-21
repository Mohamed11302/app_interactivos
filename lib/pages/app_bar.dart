import 'package:flutter/material.dart';

class MyAppBarDrawer extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange.shade400, Colors.orange.shade900],
          ),
        ),
      ),
      title: Text(
        'FindAll',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily:
              'CustomFont', // Reemplaza 'CustomFont' con el nombre de tu fuente
        ),
      ),
      leading: Builder(
        builder: (BuildContext innerContext) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(innerContext).openDrawer();
            },
          );
        },
      ),
      centerTitle: true,
    );
  }
}
