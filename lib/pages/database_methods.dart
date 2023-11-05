import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
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
  final String localizacion;
  final DateTime fecha_perdida;

  const Objeto(this.nombre, this.propietario, this.descripcion, this.perdido, this.imagen, this.localizacion, this.fecha_perdida) : super();

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) {
          return IntrinsicWidth( 
            child: AlertDialog(
            title: Text(('Más detalles sobre "' + this.nombre + '"').toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,),
            content: SingleChildScrollView(
              child: Container(
                //width: 250, // Ajusta el ancho según tus necesidades
                //height: 200, // Ajusta la altura según tus necesidades
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Descripción: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold // Subraya el texto
                            ),
                          ),
                          TextSpan(
                            text: this.descripcion+"\n",
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Fecha de desaparición confirmada: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold // Subraya el texto
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('yyyy-MM-dd HH:mm:ss').format(this.fecha_perdida).toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cerrar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
          );
        },
      );
    },
    child: Card(
      child: Container(
        height: 150,
        child: Row(
          children: <Widget>[
            Container(
              width: 150,  // Establece el ancho deseado para la imagen
              height: 150, // Establece el alto deseado para la imagen
              child: this.imagen, // Cambia esto por tu imagen
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(this.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Propietario: ' + this.propietario),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
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
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: ListView(
        children: this.objetos,
      )
    );
  }
}

Future<List<Objeto>> readObjetosPerdidos() async {

  List<Objeto> objetos_future = [];

  CollectionReference collectionReferenceObjects = db.collection('objetos');
  QuerySnapshot queryObjetos = await collectionReferenceObjects.get();

  queryObjetos.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data()as Map<String, dynamic>;
    bool perdido = data['"perdido"'];
    if (perdido){
      String descripcion = data['"descripcion"'];
      String propietario = data['"propietario"'];
      String nombre = data['"nombre"'];
      String imagen = data['"imagen"'];
      String localizacion = data['"localizacion"'];
      DateTime fecha_perdida = DateTime.parse(data['"fecha_perdida"']);
      objetos_future.add(Objeto(nombre, propietario, descripcion, perdido, Image.network(imagen),localizacion, fecha_perdida));
    }
    
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


