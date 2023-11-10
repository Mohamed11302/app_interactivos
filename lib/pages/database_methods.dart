import 'dart:io';
import 'package:app_interactivos/pages/map_lost_object.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';


final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

class Objeto extends StatelessWidget{

  final String nombre;
  final String propietario;
  final String descripcion;
  final bool perdido;
  final Image imagen; // image: Image.network('URL_DE_LA_IMAGEN'),
  final String provincia_perdida;
  final DateTime fecha_perdida;
  final List<double> coordenadas_perdida;

  const Objeto(this.nombre, this.propietario, this.descripcion, this.perdido, this.imagen, this.provincia_perdida, this.fecha_perdida, this.coordenadas_perdida) : super();

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
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Container(
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: this.descripcion + "\n",
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('yyyy-MM-dd HH:mm:ss').format(this.fecha_perdida).toString(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20), // Espacio entre el texto y el botón
                    Container(
                      width: double.infinity, // Ancho del botón al ancho completo
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), // Bordes redondeados
                        color: Colors.blue, // Color del rectángulo
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Aquí debes abrir la nueva ventana o realizar la acción deseada
                          // Por ejemplo, puedes usar Navigator.push para navegar a una nueva pantalla
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                // Coloca aquí el widget de la nueva ventana
                                // Puedes personalizarla como desees
                                return MapScreen(this.coordenadas_perdida[0],this.coordenadas_perdida[1],400); // 400 metros de radio el circulo
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Color del botón
                        ),
                        child: Text('Ver ubicación de pérdida'),
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
          ),
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
                  Text(this.nombre, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Text('Propietario: ' + this.propietario, textAlign: TextAlign.center,),
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

  final List<Objeto> objetos;

  const ListadoObjetos(this.objetos) : super();

  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      
      body: ListView(
        children: this.objetos,
      )
    );
  }
}

Future<List<Objeto>> readObjetosPerdidos(String provincia) async {

  List<Objeto> objetos_future = [];

  CollectionReference collectionReferenceObjects = db.collection('objetos');
  QuerySnapshot queryObjetos = await collectionReferenceObjects.get();

  queryObjetos.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data()as Map<String, dynamic>;

    bool perdido = data['"perdido"'];
    String provincia_perdida = data['"provincia_perdida"'];
    
    if (perdido && provincia == provincia_perdida){
      String descripcion = data['"descripcion"'];
      String propietario = data['"propietario"'];
      String nombre = data['"nombre"'];
      String imagen = data['"imagen"'];
      DateTime fecha_perdida = DateTime.parse(data['"fecha_perdida"']);
      List<String> coordenadas = data['"coordenadas_perdida"'].split(",");
      List<double> coordenadas_perdida = [double.parse(coordenadas[0]),double.parse(coordenadas[1])];
  
      //List<String> provincia =  await obtener_Provincia_y_Pais(double.parse(coordenadas[0]), double.parse(coordenadas[1]));
      
      objetos_future.add(Objeto(nombre, propietario, descripcion, perdido, Image.network(imagen),provincia_perdida, fecha_perdida, coordenadas_perdida));
    }
    
    objetos_future.sort((a, b) => b.fecha_perdida.compareTo(a.fecha_perdida));

  });

  return objetos_future;
}

Future<void> registrarObjeto(String nombre_objeto, String descripcion_objeto, XFile imagen_objeto) async{

  String url_descarga_imagen_objeto = await subir_imagen_a_storage(File(imagen_objeto.path));
  await db.collection("objetos").add(
    {
      '"coordenadas_perdida"': "",
      '"descripcion"': descripcion_objeto,
      '"fecha_perdida"': "",
      '"imagen"': url_descarga_imagen_objeto,
      '"nombre"': nombre_objeto,
      '"perdido"': false,
      '"propietario"': "EAPrimo",
      '"provincia_perdida"': "",
    }
  );
}


Future<String> subir_imagen_a_storage(File imagen) async {
  final String nombre_imagen = imagen.path.split("/").last;
  final Reference ref = storage.ref().child("imagenes_objetos").child(nombre_imagen);
  final UploadTask uploadTask = ref.putFile(imagen);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url_descarga = await snapshot.ref.getDownloadURL();
  return url_descarga;
}






