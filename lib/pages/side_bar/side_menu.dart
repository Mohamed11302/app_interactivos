import 'dart:developer';
import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:app_interactivos/pages/chat/helper/dialogs.dart';
import 'package:app_interactivos/pages/options/about.dart';
import 'package:app_interactivos/pages/tabbed_window.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/options/settings.dart';
import 'package:app_interactivos/pages/side_bar/drawer_item.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_interactivos/pages/options/profile_screen.dart';

class NavBar extends StatelessWidget {
  static const String INICIO = 'Inicio';
  static const String CONFIGURACION = 'Configuracion';
  static const String PERFIL = 'Perfil';
  static const String ACERCADE = 'Acerca de';
  static const String COMPARTIR = 'Compartir';
  static const String CERRARSESION = 'Cerrar Sesion';

  NavBar({Key? key}) : super(key: key);
  String? name = APIs.me.name.toString();
  String? email = APIs.auth.currentUser?.email;
  String? profile_picture = APIs.me.image.toString();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(
                (name.toString().length > 32)
                    ? name.toString().substring(0, 32) + '...'
                    : name.toString(),
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              accountEmail: Text(
                (email.toString().length > 32)
                    ? email.toString().substring(0, 32) + '...'
                    : email.toString(),
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                child: Image.network(
                  profile_picture.toString(),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              )),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',
                    ),
                    fit: BoxFit.cover,
                  ))),
          ListTile(
            leading: Icon(Icons.people),
            title: Text(INICIO),
            onTap: () => onItemPressed(context, index: INICIO),
          ),
          ListTile(
            leading: Icon(Icons.account_box_rounded),
            title: Text(PERFIL),
            onTap: () => onItemPressed(context, index: PERFIL),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(ACERCADE),
            onTap: () => onItemPressed(context, index: ACERCADE),
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text(COMPARTIR),
            onTap: () => onItemPressed(context, index: COMPARTIR),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(CONFIGURACION),
            onTap: () => onItemPressed(context, index: CONFIGURACION),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(CERRARSESION),
            onTap: () => onItemPressed(context, index: CERRARSESION),
          ),
        ],
      ),
    );
  }

  _signOut(BuildContext context) async {
    try {
      //for showing progress dialog
      Dialogs.showProgressBar(context);
      await APIs.updateActiveStatus(false);

      //sign out from app
      await APIs.auth.signOut().then((value) async {
        await GoogleSignIn().signOut().then((value) {
          //for hiding progress dialog
          Navigator.pop(context);

          //for moving to home screen
          Navigator.pop(context);

          APIs.auth = FirebaseAuth.instance;

          //replacing home screen with login screen
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => const RegisterLogin()));
        });
      });
      //await FirebaseAuth.instance.signOut();
      //await GoogleSignIn().signOut();
    } catch (e) {
      log('+++++++ Error: ${e}');
    }
  }

  void onItemPressed(BuildContext context, {required String index}) {
    Navigator.pop(context);

    switch (index) {
      case INICIO:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Tabbed_Window()));
        break;
      case PERFIL:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(user: APIs.me)));
        break;
      case CONFIGURACION:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case ACERCADE:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutPage()));
        break;
      case CERRARSESION:
        _signOut(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterLogin()));
        break;
    }
  }
}
