import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

class Objeto extends StatelessWidget{

  final String nombre;
  final String propietario;
  final String descripcion;
  final bool perdido;
  final Image imagen; // image: Image.network('URL_DE_LA_IMAGEN'),

  const Objeto(this.nombre, this.propietario, this.descripcion, this.perdido, this.imagen) : super();

  @override
  Widget build(BuildContext context){
    return Card(
      child: Container(
        height: 150,
        child: Row(
          children: <Widget>[
            Container(
            width: 150,  // Establece el ancho deseado para la imagen
            height: 150, // Establece el alto deseado para la imagen
            child: this.imagen,
          ),
            Expanded(
              child : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Text(this.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Propietario: '+this.propietario),
                //Text("Detalles : " + this.descripcion)
              ]
            )
            )
          ],
        )
      )
    );
  }
}

class ListadoObjetos extends StatelessWidget {

  final String titulo;
  final List<Objeto> objetos;

  const ListadoObjetos(this.titulo, this.objetos) : super();

  @override
  Widget build(BuildContext context){
    const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: AppBar(
        title: Text(this.titulo, style: optionStyle,),
      ),
      body: ListView(
        children: this.objetos,
      )
    );
  }
}

Future<List<Objeto>> readObjetos() async {

  List<Objeto> objetos_future = [];

  CollectionReference collectionReferenceObjects = db.collection('objetos');
  QuerySnapshot queryObjetos = await collectionReferenceObjects.get();

  queryObjetos.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data()as Map<String, dynamic>;
    String descripcion = data['"descripcion"'];
    String propietario = data['"propietario"'];
    String nombre = data['"nombre"'];
    bool perdido = data['"perdido"'];
    String imagen = data['"imagen"'];
    
    objetos_future.add(Objeto(nombre, propietario, descripcion, perdido, Image.network(imagen)));
  });

  return objetos_future;
}

Future<XFile?> seleccionarImagen() async{
  final ImagePicker picker = ImagePicker();
  final XFile? imagen = await picker.pickImage(source:ImageSource.gallery); //si pones camera en vez de gallery se hace foto con la camara
  return imagen;
}

Future<String> subirImagen(File imagen) async {
  final String nombre_imagen = imagen.path.split("/").last;
  final Reference ref = storage.ref().child("imagenes_objetos").child(nombre_imagen);
  final UploadTask uploadTask = ref.putFile(imagen);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url_descarga = await snapshot.ref.getDownloadURL();
  return url_descarga;
}


void getDownloadURL() async {
  final imagen = await seleccionarImagen();
  if (imagen != null){
    final url_descarga = await subirImagen(File(imagen!.path));
    print(url_descarga);
  }

}


