import 'dart:io';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/chat/chat_screen.dart';
import 'package:app_interactivos/pages/chat/data/chat_user.dart';
import 'package:app_interactivos/pages/selector_lost_area.dart';
import 'package:app_interactivos/pages/lost_object_map.dart';
import 'package:app_interactivos/pages/new_object_form.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

class Objeto_Perdido extends StatelessWidget {
  final String id_objeto;
  final String nombre;
  final String propietario;
  final String descripcion;
  final bool perdido;
  final Image imagen; // image: Image.network('URL_DE_LA_IMAGEN'),
  final String provincia_perdida;
  final DateTime fecha_perdida;
  final List<double> coordenadas_perdida;
  final double radio_area_perdida;

  const Objeto_Perdido(
      this.id_objeto,
      this.nombre,
      this.propietario,
      this.descripcion,
      this.perdido,
      this.imagen,
      this.provincia_perdida,
      this.fecha_perdida,
      this.coordenadas_perdida,
      this.radio_area_perdida)
      : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return IntrinsicWidth(
              child: AlertDialog(
                title: Text(
                  ('Más detalles sobre "' + this.nombre + '"').toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                content: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 100),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          this.imagen,
                          SizedBox(height: 20),
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
                                  text: DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(this.fecha_perdida)
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                              height: 20), // Espacio entre el texto y el botón
                          Container(
                            width: double
                                .infinity, // Ancho del botón al ancho completo
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  8), // Bordes redondeados
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
                                      return MapScreen(
                                          this.coordenadas_perdida[0],
                                          this.coordenadas_perdida[1],
                                          this.radio_area_perdida); // 400 metros de radio el circulo
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
          width: 200,
          height: 225,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                width: 150, // Establece el ancho deseado para la imagen
                height: 150, // Establece el alto deseado para la imagen
                child: this.imagen, // Cambia esto por tu imagen
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Text(
                  this.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Listado_Objetos_Perdidos extends StatelessWidget {
  final List<Objeto_Perdido> objetos;
  final Function callback_refrescar; // Callback para recargar

  Listado_Objetos_Perdidos(this.objetos, this.callback_refrescar);

  Future<void> _handleRefresh() {
    return Future.delayed(Duration(seconds: 1), () {
      callback_refrescar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh:
              _handleRefresh, // Llama a la función de callback al deslizar hacia abajo
          child: Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: (this.objetos.length / 2).ceil(),
              itemBuilder: (BuildContext context, index) {
                final firstIndex = index * 2;
                final secondIndex = firstIndex + 1;

                return Row(
                  children: [
                    if (firstIndex < this.objetos.length)
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: this.objetos[firstIndex],
                      ),
                    if (secondIndex < this.objetos.length)
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: this.objetos[secondIndex],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Objeto_Registrado extends StatefulWidget {
  final String id_objeto;
  final String nombre;
  final String propietario;
  final String descripcion;
  final bool perdido;
  final Image imagen; // image: Image.network('URL_DE_LA_IMAGEN'),
  final String provincia_perdida;
  final DateTime fecha_perdida;
  final List<double> coordenadas_perdida;
  final String url_descarga_imagen;
  final Function callback_borrar;
  final double radio_area_perdida;

  const Objeto_Registrado(
      this.id_objeto,
      this.nombre,
      this.propietario,
      this.descripcion,
      this.perdido,
      this.imagen,
      this.provincia_perdida,
      this.fecha_perdida,
      this.coordenadas_perdida,
      this.url_descarga_imagen,
      this.callback_borrar,
      this.radio_area_perdida)
      : super();

  @override
  _Objeto_Registrado createState() => _Objeto_Registrado(
      this.id_objeto,
      this.nombre,
      this.propietario,
      this.descripcion,
      this.perdido,
      this.imagen,
      this.provincia_perdida,
      this.fecha_perdida,
      this.coordenadas_perdida,
      this.url_descarga_imagen,
      this.callback_borrar,
      this.radio_area_perdida);
}

class _Objeto_Registrado extends State<Objeto_Registrado> {
  final String id_objeto;
  final String nombre;
  final String propietario;
  final String descripcion;
  final bool perdido;
  final Image imagen;
  final String provincia_perdida;
  final DateTime fecha_perdida;
  final List<double> coordenadas_perdida;
  final String url_descarga_imagen;
  final Function callback_borrar;
  final double radio_area_perdida;

  _Objeto_Registrado(
      this.id_objeto,
      this.nombre,
      this.propietario,
      this.descripcion,
      this.perdido,
      this.imagen,
      this.provincia_perdida,
      this.fecha_perdida,
      this.coordenadas_perdida,
      this.url_descarga_imagen,
      this.callback_borrar,
      this.radio_area_perdida)
      : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                ('Más detalles sobre "' + this.nombre + '"').toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 100),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        this.imagen,
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Text.rich(
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
                        ),
                        this.perdido
                            ? Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text:
                                          'Fecha de desaparición confirmada: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(this.fecha_perdida)
                                          .toString(),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(height: 0),
                        this.perdido
                            ? SizedBox(height: 20)
                            : SizedBox(height: 0),
                        this.perdido
                            ? Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.blue,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MapScreen(
                                              this.coordenadas_perdida[0],
                                              this.coordenadas_perdida[1],
                                              this.radio_area_perdida);
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: Text('Ver ubicación de pérdida'),
                                ),
                              )
                            : SizedBox(height: 0),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Formulario_Objeto(
                                          this.nombre,
                                          this.descripcion,
                                          this.url_descarga_imagen);
                                    },
                                  ),
                                ).then((resultado_formulario) async {
                                  if (resultado_formulario != null) {
                                    String url_usar = this.url_descarga_imagen;
                                    if (resultado_formulario.nueva_imagen) {
                                      url_usar = await subir_imagen_a_storage(
                                          resultado_formulario.imagen_objeto);
                                      borrar_imagen_storage(this
                                          .url_descarga_imagen); //se borra la foto que tenía el objeto para no colapsar el storage
                                    }
                                    final objeto_aux = Objeto_Registrado(
                                        this.id_objeto,
                                        resultado_formulario.nombre_objeto,
                                        this.propietario,
                                        resultado_formulario.descripcion_objeto,
                                        this.perdido,
                                        Image.file(
                                            resultado_formulario.imagen_objeto),
                                        this.provincia_perdida,
                                        this.fecha_perdida,
                                        this.coordenadas_perdida,
                                        url_usar,
                                        this.callback_borrar,
                                        this.radio_area_perdida);
                                    Navigator.of(context).pop();
                                    actualizar_objeto_firestore(objeto_aux);
                                    objeto_aux.callback_borrar();
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: Column(
                                children: [Icon(Icons.edit), Text("Editar")],
                              ),
                            ),
                            SizedBox(width: 5.5),
                            this.perdido
                                ? ElevatedButton(
                                    onPressed: () async {
                                      Objeto_Registrado objeto_aux =
                                          Objeto_Registrado(
                                              this.id_objeto,
                                              this.nombre,
                                              this.propietario,
                                              this.descripcion,
                                              false,
                                              this.imagen,
                                              "",
                                              DateTime.now(),
                                              [0, 0],
                                              this.url_descarga_imagen,
                                              callback_borrar,
                                              this.radio_area_perdida);
                                      actualizar_objeto_firestore(objeto_aux);
                                      Navigator.of(context).pop();
                                      objeto_aux.callback_borrar();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.check),
                                        Text("Hallado")
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            // Coloca aquí el widget de la nueva ventana
                                            // Puedes personalizarla como desees
                                            return MapSelector(
                                                400); // 400 metros de radio el circulo
                                          },
                                        ),
                                      ).then((resultado_mapa) async {
                                        if (resultado_mapa != null) {
                                          Objeto_Registrado objeto_aux =
                                              Objeto_Registrado(
                                                  this.id_objeto,
                                                  this.nombre,
                                                  this.propietario,
                                                  this.descripcion,
                                                  true,
                                                  this.imagen,
                                                  resultado_mapa["province"],
                                                  DateTime.now(),
                                                  [
                                                    resultado_mapa["location"]
                                                        .latitude,
                                                    resultado_mapa["location"]
                                                        .longitude
                                                  ],
                                                  this.url_descarga_imagen,
                                                  callback_borrar,
                                                  resultado_mapa['radius']);
                                          actualizar_objeto_firestore(
                                              objeto_aux);
                                          Navigator.of(context).pop();
                                          objeto_aux.callback_borrar();
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow,
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.warning),
                                        Text("Perdido")
                                      ],
                                    ),
                                  ),
                            SizedBox(width: 5.5),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '¿Desea borrar los datos sobre el objeto "' +
                                            this.nombre +
                                            '"?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: Text('No',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                              ),
                                              child: Text('Sí'),
                                              onPressed: () {
                                                borrar_imagen_storage(
                                                    this.url_descarga_imagen);
                                                borrar_objeto_firestore(
                                                    id_objeto);
                                                callback_borrar();
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.delete),
                                  Text("Borrar"),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
            );
          },
        );
      },
      child: Card(
        child: Container(
          width: 200,
          height: 225,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                width: 150, // Ancho deseado para la imagen
                height: 150, // Alto deseado para la imagen
                child: this.imagen, // Cambia esto por tu imagen
              ),
              SizedBox(height: 20),
              Expanded(
                child: Text(
                  this.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Listado_Objetos_Registrados extends StatelessWidget {
  final List<Objeto_Registrado> objetos;

  const Listado_Objetos_Registrados(this.objetos) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical, // Columna vertical
            itemCount: (this.objetos.length / 2)
                .ceil(), // Divide por 2 y redondea hacia arriba
            itemBuilder: (BuildContext context, index) {
              final firstIndex = index * 2;
              final secondIndex = firstIndex + 1;

              return Row(
                children: [
                  if (firstIndex < this.objetos.length)
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: this.objetos[firstIndex],
                    ),
                  if (secondIndex < this.objetos.length)
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: this.objetos[secondIndex],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<Objeto_Perdido>> readObjetosPerdidos(String provincia) async {
  List<Objeto_Perdido> objetos_future = [];

  CollectionReference collectionReferenceObjects = db.collection('objetos');
  QuerySnapshot queryObjetos = await collectionReferenceObjects.get();

  queryObjetos.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;

    bool perdido = data['"perdido"'];
    String provincia_perdida = data['"provincia_perdida"'];

    if (perdido && provincia == provincia_perdida) {
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

      objetos_future.add(Objeto_Perdido(
          id_objeto,
          nombre,
          propietario,
          descripcion,
          perdido,
          Image.network(imagen),
          provincia_perdida,
          fecha_perdida,
          coordenadas_perdida,
          radio_area_perdida));
    }

    objetos_future.sort((a, b) => b.fecha_perdida.compareTo(a.fecha_perdida));
  });

  return objetos_future;
}

Future<void> registrarObjeto(String nombre_objeto, String descripcion_objeto,
    File imagen_objeto, String cuenta_usuario) async {
  String url_descarga_imagen_objeto =
      await subir_imagen_a_storage(imagen_objeto);

  await db.collection("objetos").add({
    '"coordenadas_perdida"': "",
    '"descripcion"': descripcion_objeto,
    '"fecha_perdida"': "",
    '"imagen"': url_descarga_imagen_objeto,
    '"nombre"': nombre_objeto,
    '"perdido"': false,
    '"propietario"': cuenta_usuario,
    '"provincia_perdida"': "",
    '"radio_area_perdida"': "",
  });
}

Future<String> subir_imagen_a_storage(File imagen) async {
  final String nombre_imagen = imagen.path.split("/").last;
  final Reference ref =
      storage.ref().child("imagenes_objetos").child(nombre_imagen);
  final UploadTask uploadTask = ref.putFile(imagen);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  final String url_descarga = await snapshot.ref.getDownloadURL();
  return url_descarga;
}

Future<List<Objeto_Registrado>> readObjetosRegistrados(
    String cuenta_usuario, Function funcion_callback_borrar) async {
  List<Objeto_Registrado> objetos_future = [];

  CollectionReference collectionReferenceObjects = db.collection('objetos');
  QuerySnapshot queryObjetos = await collectionReferenceObjects.get();

  queryObjetos.docs.forEach((documento) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    String propietario = data['"propietario"'];

    if (cuenta_usuario == propietario) {
      String id_objeto = documento.id;
      bool perdido = data['"perdido"'];
      String descripcion = data['"descripcion"'];
      String nombre = data['"nombre"'];
      String imagen = data['"imagen"'];

      if (perdido) {
        DateTime fecha_perdida = DateTime.parse(data['"fecha_perdida"']);
        String provincia_perdida = data['"provincia_perdida"'];
        List<String> coordenadas = data['"coordenadas_perdida"'].split(",");
        List<double> coordenadas_perdida = [
          double.parse(coordenadas[0]),
          double.parse(coordenadas[1])
        ];
        double radio_area_perdida = double.parse(data['"radio_area_perdida"']);

        objetos_future.add(Objeto_Registrado(
            id_objeto,
            nombre,
            propietario,
            descripcion,
            perdido,
            Image.network(imagen),
            provincia_perdida,
            fecha_perdida,
            coordenadas_perdida,
            imagen,
            funcion_callback_borrar,
            radio_area_perdida));
      } else {
        objetos_future.add(Objeto_Registrado(
            id_objeto,
            nombre,
            propietario,
            descripcion,
            perdido,
            Image.network(imagen),
            "",
            DateTime.now(),
            [0, 0],
            imagen,
            funcion_callback_borrar,
            0));
      }
    }
  });

  return objetos_future;
}

void borrar_imagen_storage(String url_descarga) {
  Reference referenciaImagen =
      FirebaseStorage.instance.refFromURL(url_descarga);

  referenciaImagen.delete().then((_) {}).catchError((error) {
    print('Error al eliminar la imagen: $error');
  });
}

void borrar_objeto_firestore(String id_objeto) {
  CollectionReference ref_objetos =
      FirebaseFirestore.instance.collection('objetos');
  DocumentReference docRef = ref_objetos.doc(id_objeto);
  docRef.delete().then((_) {}).catchError((error) {
    print('Error al eliminar el documento: $error');
  });
}

Future<void> actualizar_objeto_firestore(Objeto_Registrado objeto) async {
  await db.collection("objetos").doc(objeto.id_objeto).set({
    '"coordenadas_perdida"': objeto.coordenadas_perdida[0].toString() +
        "," +
        objeto.coordenadas_perdida[1].toString(),
    '"descripcion"': objeto.descripcion,
    '"fecha_perdida"': objeto.fecha_perdida.toString(),
    '"imagen"': objeto.url_descarga_imagen,
    '"nombre"': objeto.nombre,
    '"perdido"': objeto.perdido,
    '"propietario"': objeto.propietario,
    '"provincia_perdida"': objeto.provincia_perdida,
    '"radio_area_perdida"': objeto.radio_area_perdida.toString(),
  });
}

Future<void> leer_objeto_concreto(String id_documento, context) async {
  try {
    DocumentSnapshot documento = await FirebaseFirestore.instance
        .collection('objetos')
        .doc(id_documento)
        .get();

    if (documento.exists) {
      Map<String, dynamic> datos = documento.data() as Map<String, dynamic>;
      print("Propietario del objeto: " + datos['"propietario"']);

      /// ABRIR CHAT
      await APIs.addChatUser(datos['"propietario"']).then((value) async {
        if (!value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Ese usuario no existe')));
        } else {
          DocumentSnapshot documento_propietario = await FirebaseFirestore
              .instance
              .collection('users')
              .doc(datos['"propietario"'])
              .get();
          Map<String, dynamic> datos_propietario =
              documento_propietario.data() as Map<String, dynamic>;
          ChatUser chatuser = ChatUser(
              image: datos_propietario['image'],
              about: datos_propietario['about'],
              name: datos_propietario['name'],
              createdAt: datos_propietario['created_at'],
              isOnline: datos_propietario['is_online'],
              id: datos_propietario['id'],
              lastActive: datos_propietario['last_active'],
              email: datos_propietario['email'],
              pushToken: datos_propietario['push_token']);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(user: chatuser)));
        }
      });

      /// ABRIR CHAT
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('El objeto ya no se ha encuentra registrado')));
    }
  } catch (e) {
    print("Error al leer el objeto desde la base de datos: $e");
  }
}
