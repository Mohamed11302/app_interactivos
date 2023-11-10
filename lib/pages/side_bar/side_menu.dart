import 'dart:developer';

import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/side_bar/drawer_item.dart';
import 'package:app_interactivos/pages/side_bar/people.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NavigDrawer extends StatelessWidget {
  NavigDrawer({Key? key}) : super(key: key);
  String? name = APIs.auth.currentUser?.displayName;
  String? email = APIs.auth.currentUser?.email;
  String? profile_picture = APIs.auth.currentUser?.photoURL;
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
                onPressed: () => onItemPressed(context, index: 0),
              ),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Perfil',
                  icon: Icons.account_box_rounded,
                  onPressed: () => onItemPressed(context, index: 1)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Ajustes',
                  icon: Icons.settings,
                  onPressed: () => onItemPressed(context, index: 4)),
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
                  onPressed: () => onItemPressed(context, index: 3)),
              const SizedBox(
                height: 30,
              ),
              DrawerItem(
                  name: 'Log out',
                  icon: Icons.logout,
                  onPressed: () {
                    onItemPressed(context, index: 5);
                    _signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterLogin()),
                        (route) => false);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      log('+++++++ Error: ${e}');
    }
  }

  void onItemPressed(BuildContext context, {required int index}) {
    Navigator.pop(context);

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const People()));
        break;
    }
  }

  Widget headerWidget() {
    //const url =
    // 'https://media.istockphoto.com/photos/learn-to-love-yourself-first-picture-id1291208214?b=1&k=20&m=1291208214&s=170667a&w=0&h=sAq9SonSuefj3d4WKy4KzJvUiLERXge9VgZO-oqKUOo=';
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          //backgroundImage: AssetImage('assets/default_profile_picture.jpeg'),
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
