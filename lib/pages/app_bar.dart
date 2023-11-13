import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/api/api.dart';

class MyAppBarDrawer extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 20,
      title: Text(
        'FindAll',
        style: TextStyle(color: Colors.white),
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
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundImage: Image.network(APIs.me.image.toString()).image,
          ),
          onPressed: () {
            // Lógica que se ejecuta al presionar el botón de la imagen
            print('Botón de imagen presionado');
            //log(APIs.user.uid.toString());
          },
        ),
      ],
      centerTitle: true,
    );
  }
}
