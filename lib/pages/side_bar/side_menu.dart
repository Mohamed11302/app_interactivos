import 'dart:developer';
import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:app_interactivos/pages/chat/data/chat_user.dart';
import 'package:app_interactivos/pages/chat/helper/dialogs.dart';
import 'package:app_interactivos/pages/options/about.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_interactivos/pages/options/profile_screen.dart';

class NavBar extends StatelessWidget {
  static const String INICIO = 'Inicio';
  static const String PERFIL = 'Perfil';
  static const String ACERCADE = 'Acerca de';
  static const String COMPARTIR = 'Compartir';
  static const String CERRARSESION = 'Cerrar Sesion';

  static String opcion_actual = INICIO;

  NavBar({Key? key}) : super(key: key);
  String? _email = APIs.user.email!;
  String? _image_database = APIs.user.photoURL!;
  String? _name = APIs.user.displayName!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String?>>(
        future: Future.wait([
          APIs.getRegistroUser('name'),
          APIs.getRegistroUser('image'),
          APIs.getRegistroUser('email'),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                      accountName: Text(
                        (_name.toString().length > 32)
                            ? _name.toString().substring(0, 32) + '...'
                            : _name.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      accountEmail: Text(
                        (_email.toString().length > 32)
                            ? _email.toString().substring(0, 32) + '...'
                            : _email.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      currentAccountPicture: CircleAvatar(
                          child: ClipOval(
                        child: Image.network(
                          _image_database.toString(),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: Image.asset('assets/background.jpg').image,
                            fit: BoxFit.cover,
                          ))),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text(INICIO),
                    onTap: () => onItemPressed(context, index: INICIO),
                  ),
                  Divider(),
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
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(CERRARSESION),
                    onTap: () => onItemPressed(context, index: CERRARSESION),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Maneja cualquier error que pueda ocurrir durante la llamada a la API
          } else {
            _name = snapshot.data?[0] ?? '';
            _image_database = snapshot.data?[1] ?? '';
            _email = snapshot.data?[2] ?? '';
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                      accountName: Text(
                        (_name.toString().length > 32)
                            ? _name.toString().substring(0, 32) + '...'
                            : _name.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      accountEmail: Text(
                        (_email.toString().length > 32)
                            ? _email.toString().substring(0, 32) + '...'
                            : _email.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      currentAccountPicture: CircleAvatar(
                          child: ClipOval(
                        child: Image.network(
                          _image_database.toString(),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      )),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: Image.asset('assets/background.jpg').image,
                            fit: BoxFit.cover,
                          ))),
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text(INICIO),
                    onTap: () => onItemPressed(context, index: INICIO),
                  ),
                  Divider(),
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
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(CERRARSESION),
                    onTap: () => onItemPressed(context, index: CERRARSESION),
                  ),
                ],
              ),
            );
          }
        });
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

  void callback_boton_retroceso(){
   opcion_actual = INICIO;
  }

  void onItemPressed(BuildContext context, {required String index}) async {
    Navigator.pop(context);
    
    switch (index) {
      case INICIO:
        if (opcion_actual != INICIO){
          opcion_actual = INICIO;
          Navigator.of(context).pop();
        }
        break;
      case PERFIL:
        if (opcion_actual != PERFIL){
          ChatUser chatuser = await CrearChatUserPersonalizado();
          if (opcion_actual != INICIO)
            Navigator.of(context).pop();
            
          opcion_actual = PERFIL;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: chatuser, callback_boton_retroceso: callback_boton_retroceso)));
        }
        break;
      case ACERCADE:
        if (opcion_actual != ACERCADE){

          if (opcion_actual != INICIO)
            Navigator.of(context).pop();
            
          opcion_actual = ACERCADE;
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AboutPage(callback_boton_retroceso)));
        }
        break;
      case CERRARSESION:
        _signOut(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterLogin()));
        break;
    }
  }

  Future<ChatUser> CrearChatUserPersonalizado() async {
    String? about = await APIs.getRegistroUser('about');
    ChatUser chatuser = ChatUser(
        image: _image_database.toString(),
        about: about.toString(),
        name: _name.toString(),
        createdAt: '',
        isOnline: false,
        id: '',
        lastActive: '',
        email: '',
        pushToken: '');
    return chatuser;
  }
}
