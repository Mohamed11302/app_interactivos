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

class NavigDrawer extends StatelessWidget {
  static const String INICIO = 'Inicio';
  static const String CONFIGURACION = 'Configuracion';
  static const String PERFIL = 'Perfil';
  static const String ACERCADE = 'Acerca de';
  static const String CERRARSESION = 'Cerrar Sesion';

  NavigDrawer({Key? key}) : super(key: key);
  String? name = APIs.me.name.toString();
  String? email = APIs.auth.currentUser?.email;
  String? profile_picture = APIs.me.image.toString();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 80, 24, 0),
          child: Column(
            children: [
              headerWidget(),
              const SizedBox(
                height: 40,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 40,
              ),
              DrawerItem(
                name: 'Inicio',
                icon: Icons.people,
                onPressed: () => onItemPressed(context, index: INICIO),
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Perfil',
                  icon: Icons.account_box_rounded,
                  onPressed: () => onItemPressed(context, index: PERFIL)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Configuracion',
                  icon: Icons.settings,
                  onPressed: () =>
                      onItemPressed(context, index: CONFIGURACION)),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Acerca de',
                  icon: Icons.info,
                  onPressed: () => onItemPressed(context, index: ACERCADE)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Log out',
                  icon: Icons.logout,
                  onPressed: () => onItemPressed(context, index: CERRARSESION)),
            ],
          ),
        ),
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

  Widget headerWidget() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(profile_picture.toString()),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              (name.toString().length > 17)
                  ? name.toString().substring(0, 17) + '...'
                  : name.toString(),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              (email.toString().length > 17)
                  ? email.toString().substring(0, 17) + '...'
                  : email.toString(),
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          ],
        )
      ],
    );
  }
}
