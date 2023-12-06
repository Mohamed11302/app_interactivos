import 'dart:developer';
import 'dart:io';

import 'package:app_interactivos/pages/chat/conversation_objetc_list.dart';
import 'package:app_interactivos/pages/database_methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/chat/helper/my_date_util.dart';
import 'package:app_interactivos/main.dart';
import 'package:app_interactivos/pages/chat/data/chat_user.dart';
import 'package:app_interactivos/pages/chat/data/message.dart';
import 'package:app_interactivos/pages/chat/helper/message_card.dart';
import 'view_profile_screen.dart';


class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;
  
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Objeto_Perdido> listado_objetos_conver = [];
  bool lectura_objetos_perdidos_acabada = true;
  
  _ChatScreenState();

  void consigue_objetos_conver() async{

    List<String> conjunto_ids_objetos_conver = [];

    //Cojo el id del documento que contiene los objetos de la conversacion entre los dos usuarios
    var snapshot_chats = await firestore
        .collection('users')
        .doc(APIs.auth.currentUser!.email)
        .collection('my_chats')
        .doc(widget.user.email)
        .get();
       
    // Cojo los ids de objetos dentro de la lista de los objetos de la conversación de los dos usuarios

      var snapshot_2 = await firestore
          .collection('objeto_conversaciones')
          .doc(snapshot_chats["objetos_conver"])
          .collection('lista_objetos')
          .get();

      for (var document_2 in snapshot_2.docs) {
        conjunto_ids_objetos_conver.add(document_2.id);
      }  
    
    consigueObjetos(conjunto_ids_objetos_conver);
  

  }

  void consigueObjetos(List<String> ids_objetos) async {
    setState(() {
      lectura_objetos_perdidos_acabada = false;
    });

    listado_objetos_conver = await readObjetosConver(ids_objetos);

    setState(() {
      lectura_objetos_perdidos_acabada = true;
    });

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Listado_Objetos_Conversacion(this.listado_objetos_conver,);
        },
      ),
    ); 
  }

  Future<List<Objeto_Perdido>> readObjetosConver(List<String> ids_objetos) async {
    List<Objeto_Perdido> objetos_future = [];

    CollectionReference collectionReferenceObjects = db.collection('objetos');
    QuerySnapshot queryObjetos = await collectionReferenceObjects.get();

    queryObjetos.docs.forEach((documento) {
      Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

      ids_objetos.forEach((String id_objeto) {
        
        if (id_objeto == documento.id){
          bool perdido = data['"perdido"'];
          String provincia_perdida = data['"provincia_perdida"'];
          String id_objeto = documento.id;
          String descripcion = data['"descripcion"'];
          String propietario = data['"propietario"'];
          String nombre = data['"nombre"'];
          String imagen = data['"imagen"'];
          DateTime fecha_perdida = DateTime.parse(data['"fecha_perdida"']);
          List<String> coordenadas = data['"coordenadas_perdida"'].split(",");
          List<double> coordenadas_perdida = [
            double.parse(coordenadas[0]),
            double.parse(coordenadas[1])
          ];
          double radio_area_perdida = double.parse(data['"radio_area_perdida"']);
          objetos_future.add(
            Objeto_Perdido(
              id_objeto,
              nombre,
              propietario,
              descripcion,
              perdido,
              Image.network(imagen),
              provincia_perdida,
              fecha_perdida,
              coordenadas_perdida,
              radio_area_perdida
            )
          );
        }

      });
      
    });

    objetos_future.sort((a, b) => b.fecha_perdida.compareTo(a.fecha_perdida));

    return objetos_future;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if emojis are shown & back button is pressed then hide emojis
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() => _showEmoji = !_showEmoji);
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            //app bar
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),

            backgroundColor: const Color.fromARGB(255, 234, 248, 255),

            //body
            body: Column(
              children: [
                SizedBox(height: 10),
                this.lectura_objetos_perdidos_acabada ? 
                  ElevatedButton(
                    onPressed: () {
                      consigue_objetos_conver();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color del botón
                      maximumSize: Size(315, 40), // Establece el tamaño mínimo del botón
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.question_mark),
                        SizedBox(width: 5),
                        Text('Objetos tratados en la conversación'),
                      ],
                    ),
                  )
                    :
                    Center(child: CircularProgressIndicator()),
                SizedBox(height: 10),
                Container(
                  height: 1,
                  color: Colors.black26,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('¡Avisa al usuario de tu hallazgo!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),

                //chat input filed
                _chatInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  //back button
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_back, color: Colors.black54)),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      width: mq.height * .05,
                      height: mq.height * .05,
                      imageUrl:
                          list.isNotEmpty ? list[0].image : widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  //for adding some space
                  const SizedBox(width: 10),

                  //user name & last seen time
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //user name
                      Text(list.isNotEmpty ? list[0].name : widget.user.name,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500)),

                      //for adding some space
                      const SizedBox(height: 2),

                      //last seen time of user
                      Text(
                          list.isNotEmpty
                              ? list[0].isOnline
                                  ? 'Online'
                                  : MyDateUtil.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].lastActive)
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: widget.user.lastActive),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54)),
                    ],
                  )
                ],
              );
            }));
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emoji button
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() => _showEmoji = !_showEmoji);
                      },
                      icon: const Icon(Icons.emoji_emotions,
                          color: Colors.blueAccent, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Picking multiple images
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);

                        // uploading & sending image one by one
                        for (var i in images) {
                          log('Image Path: ${i.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.blueAccent, size: 26)),

                  //take image from camera button
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);

                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      icon: const Icon(Icons.camera_alt_rounded,
                          color: Colors.blueAccent, size: 26)),

                  //adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}
