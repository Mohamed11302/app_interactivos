import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigDrawer(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
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
                backgroundImage: NetworkImage(APIs.auth.currentUser!.photoURL
                    .toString())), // Reemplaza 'tu_ruta_de_imagen' con la ruta correcta
            onPressed: () {
              // Lógica que se ejecuta al presionar el botón de la imagen
              print('Botón de imagen presionado');
              //log(APIs.user.uid.toString());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Text('Pestaña Acerca De'),
      ),
    );
  }
}
