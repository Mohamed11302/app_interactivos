// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_interactivos/pages/app_bar.dart';
import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:app_interactivos/pages/database_methods.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/chat/helper/dialogs.dart';
import 'package:app_interactivos/main.dart';
import 'package:app_interactivos/pages/chat/data/chat_user.dart';
import 'package:app_interactivos/pages/new_object_form.dart';

//profile screen -- to show signed in user info
class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  final Function callback_boton_retroceso;
  const ProfileScreen({super.key, required this.user, required this.callback_boton_retroceso});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(callback_boton_retroceso);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  Function callback_boton_retroceso;

  _ProfileScreenState(this.callback_boton_retroceso);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
          
          this.callback_boton_retroceso();
          return true; // Cambia a false para bloquear el retroceso
        },
        child :GestureDetector(
            // for hiding keyboard
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                //app bar
                backgroundColor: Colors.white,
                appBar: MyAppBarDrawer(),
                drawer: NavBar(),
                //body
                body: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // for adding some space
                          SizedBox(width: mq.width, height: mq.height * .03),
                          Text(
                            'Perfil',
                            style: TextStyle(
                              color: Colors.black, // Texto negro
                              fontSize: 30, // Ajusta el tamaño del texto
                              fontWeight:
                                  FontWeight.bold, // Ajusta el peso del texto
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 1,
                            color: Colors.black26, // Línea divisoria
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          //user profile picture
                          Stack(
                            children: [
                              //profile picture
                              _image != null
                                  ?

                                  //local image
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .1),
                                      child: Image.file(File(_image!),
                                          width: mq.height * .2,
                                          height: mq.height * .2,
                                          fit: BoxFit.cover))
                                  :

                                  //image from server
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(mq.height * .1),
                                      child: CachedNetworkImage(
                                        width: mq.height * .2,
                                        height: mq.height * .2,
                                        fit: BoxFit.cover,
                                        imageUrl: widget.user.image,
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                                child: Icon(CupertinoIcons.person)),
                                      ),
                                    ),

                              //edit image button
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: MaterialButton(
                                  elevation: 1,
                                  onPressed: () {
                                    _showBottomSheet();
                                  },
                                  shape: const CircleBorder(),
                                  color: Colors.white,
                                  child: const Icon(Icons.edit, color: Colors.orange),
                                ),
                              )
                            ],
                          ),

                          // for adding some space
                          SizedBox(height: mq.height * .01),

                          // user email label
                          Text(widget.user.email,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 16)),

                          // for adding some space
                          SizedBox(height: mq.height * .05),

                          // name input field
                          TextFormField(
                            initialValue: widget.user.name,
                            onSaved: (val) => APIs.me.name = val ?? '',
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : 'Campo obligatorio',
                            decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.person, color: Colors.orange),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                hintText: 'ejemplo: User123123',
                                label: const Text('Nombre de usuario')),
                          ),

                          // for adding some space
                          SizedBox(height: mq.height * .02),

                          // about input field
                          TextFormField(
                            initialValue: widget.user.about,
                            onSaved: (val) => APIs.me.about = val ?? '',
                            validator: (val) => val != null && val.isNotEmpty
                                ? null
                                : 'Campo obligatorio',
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.info_outline,
                                    color: Colors.orange),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                hintText: 'ejemplo: ¡Buenos días a todos!',
                                label: const Text('Acerca de mi')),
                          ),

                          // for adding some space
                          SizedBox(height: mq.height * .05),

                          // update profile button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(), backgroundColor: Colors.orange[700],
                                minimumSize: Size(mq.width * .5, mq.height * .06), // Color primario del botón
                                ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                APIs.updateUserInfo().then((value) {
                                  Dialogs.showSnackbar(
                                      context, 'Los datos han sido actualizados');
                                });
                              }
                            },
                            icon: const Icon(Icons.edit, size: 28),
                            label: const Text('ACTUALIZAR',
                                style: TextStyle(fontSize: 16)),
                          ),

                          SizedBox(height: mq.height * .05),

                          // update profile button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(), backgroundColor: Colors.red[900],
                                minimumSize: Size(mq.width * .5, mq.height * .06), // Color primario del botón
                                ),
                            onPressed: () async{
                              ShowDialogDeleteAccount();
                            },
                            icon: const Icon(Icons.delete, size: 28),
                            label: const Text('BORRAR DATOS',
                                style: TextStyle(fontSize: 16)),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          )
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              const Text('Selecciona una imagen de perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              SizedBox(height: mq.height * .02),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                      
                        // Pick an image
                        final XFile? image = await seleccionarImagen(false);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/add_image.png')),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {

                        // Pick an image
                        final XFile? image = await seleccionarImagen(true);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/camera.png')),
                ],
              )
            ],
          );
        });
  }
  void ShowDialogDeleteAccount() {
    
    showDialog(context:context, builder: (BuildContext context){
        return AlertDialog(
          title: Text('Eliminar cuenta'),
          content: Text('¿Estás seguro de eliminar tu cuenta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Lógica para manejar la opción 'Sí'
                Navigator.of(context).pop(true);
                
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                // Lógica para manejar la opción 'Cancelar'
                Navigator.of(context).pop(false);
                print("Eliminar cuenta");
                await DeleteAccount();
              },
              child: Text('Si'),
            ),
          ],
        );
      }
    );
  }
  Future<void> DeleteAccount() async{
    try{
      String email = APIs.auth.currentUser!.email.toString();
      List<String> chats = [];
      List<String> objetos_conversaciones = [];
      ///////////////// ELIMINAR CHATS DEL USUARIO
      DocumentSnapshot usersColection = await APIs.firestore.collection('users').doc(email).get();
      QuerySnapshot usersChatCollection = await usersColection.reference.collection('my_chats').get();
        for (QueryDocumentSnapshot chatDocument in usersChatCollection.docs) {
            Map<String, dynamic> data2 = chatDocument.data() as Map<String, dynamic>;
            if (data2["objetos_conver"]!=null){ //AÑADO EL ID DE LA LISTA DE OBJETOS DEL CHAT PARA BORRARLA LUEGO
              objetos_conversaciones.add(data2["objetos_conver"]);
            }
            chats.add(chatDocument.id); //AÑADO EL EMAIL DEL OTRO PARTICIPANTE DEL CHAT PARA BORRARLO DESPUES
            await DeleteChat(chatDocument.id, email); //BORRO LA CONVERSACION
            print('ELIMINADO: ${chatDocument.id} ');
      }

      print(chats);
      for (String chat in chats){ //PARA LAS PERSONAS CON LAS QUE HABLA EL USUARIO
          DocumentSnapshot usersColection_dest = await APIs.firestore.collection('users').doc(chat).get();
          DocumentSnapshot querySnapshot2 = await usersColection.reference.collection('my_chats').doc(email).get();
          if (querySnapshot2.data() != null){
              Map<String, dynamic> data = querySnapshot2.data() as Map<String, dynamic>;
              if (data["objetos_conver"]!=null){
                objetos_conversaciones.add(data["objetos_conver"]);
              }
          }
          print(chat);
          print('Datos del chat: ${querySnapshot2.id}');
          await querySnapshot2.reference.delete(); //BORRO EL CORREO DEL USUARIO DE SU LISTA DE MY_CHATS
      }



      ///////////////// ELIMINAR OBJETOS Y OBJETO_CONVERSACIONES DEL PROPIETARIO
      CollectionReference objetosCollection = APIs.firestore.collection('objetos');
      QuerySnapshot querySnapshot2 = await objetosCollection.where('"propietario"', isEqualTo: email).get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
          print('Documento eliminado: ${document.data()}');
          borrar_objeto_firestore(document.id);
      }
      ///ELIMINAR LOS OBJETOS DE LA CONVERSACION SI EL OBJETO LE PERTENECE AL OTRO USUARIO
      for (String objeto_conversaciones in objetos_conversaciones){
        CollectionReference objetosconversacionCollection = APIs.firestore.collection('objetos_conversacion');
        await objetosconversacionCollection.doc(objeto_conversaciones).delete();

      }
      print("---");


      //ELIMINO LA COLECCION DE CHATS DEL PROPIO USUARIO y EL USER
      CollectionReference myChatsCollection = usersColection.reference.collection('my_chats');
      QuerySnapshot myChatsSnapshot = await myChatsCollection.get();

      for (QueryDocumentSnapshot chatDocument in myChatsSnapshot.docs) {
        await chatDocument.reference.delete();
      }
      await usersColection.reference.delete();
      await APIs.auth.currentUser!.delete();
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => RegisterLogin()), (route) => false);
    } catch (e) {
      print('+++++++ Error: ${e}');
    }
  }
  Future<void> DeleteChat(String usuario1, String usuario2) async{
    String path = 'chats/${usuario1}_${usuario2}/messages/';
    try{
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await APIs.firestore.collection(path).get();
      if (querySnapshot.size == 0){
        path = 'chats/${usuario2}_${usuario1}/messages/';
        querySnapshot = await APIs.firestore.collection(path).get();
      }
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
          await doc.reference.delete();
          print('ELIMINADO: ${path}');
      }
    }catch(e){

    }
  }

}


