import 'dart:io';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/chat/chat_screen.dart';
import 'package:app_interactivos/pages/chat/data/chat_user.dart';
import 'package:app_interactivos/pages/nfc_methods.dart';
import 'package:app_interactivos/pages/selector_lost_area.dart';
import 'package:app_interactivos/pages/lost_object_map.dart';
import 'package:app_interactivos/pages/new_object_form.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;


List<String> lista_provincias_peticiones = [
    'Araba/Álava', 'Albacete', 'Alacant / Alicante', 'Almería', 'Asturias / Asturies', 'Ávila', 'Badajoz', 'Barcelona', 'Burgos', 'Cáceres', 'Cádiz', 'Cantabria',
    'Castelló / Castellón', 'Ciudad Real', 'Córdoba', 'Cuenca', 'Girona', 'Granada', 'Guadalajara', 'Gipuzkoa', 'Huelva', 'Huesca', 'Illes Balears',
    'Jaén', 'La Coruña', 'La Rioja', 'Las Palmas', 'León', 'Lleida', 'Lugo', 'Madrid', 'Málaga', 'Región de Murcia', 'Navarra - Nafarroa', 'Ourense', 'Palencia',
    'Pontevedra', 'Salamanca', 'Santa Cruz de Tenerife', 'Segovia', 'Sevilla', 'Soria', 'Tarragona', 'Teruel', 'Toledo', 'València / Valencia',
    'Valladolid', 'Bizkaia', 'Zamora', 'Zaragoza', "<Ninguna>"
  ];

/*
List<List<double>> lista_boundingboxes_provincias = [
  [43.339594, 43.3967114, -8.4039901, -8.337817],
  [42.5050679, 42.5054317, -2.4347902, -2.4339072],
  [38.9890222, 38.9890427, -1.8569411, -1.8569148],
  [38.3190085, 38.3385968, -0.502125, -0.4825041],
  [36.825363, 36.8374452, -2.4876223, -2.4640462],
  [42.8825428, 43.6665324, -7.1831688, -4.5105944],
  [40.452429, 40.8039003, -5.0968946, -4.419186],
  [41.4004595, 41.401119, 2.191481, 2.1923962],
  [41.4212127, 41.4220829, 2.2256955, 2.2273087],
  [42.1008625, 42.68048, -4.335344, -3.4818446],
  [39.1552618, 39.6488278, -6.8020698, -6.0787446],
  [36.547529, 36.547629, -6.26906, -6.26896],
  [42.7580499, 43.5136234, -4.8517354, -3.149652],
  [200,200,200,200],//CASTELLON, 12
  [38.9834549, 38.9841807, -3.9172587, -3.9167733],
  [37.9029236, 37.9770126, -4.8630668, -4.7822059],
  [41.9281769, 41.9282769, -0.8690428, -0.8689428],
  [38.7801284, 38.8649568, -0.2081167, 0.0252403],
  [40.943549, 40.943649, 0.6550498, 0.6551498],
  [40.6366874, 40.6400763, -3.1777646, -3.1737583],
  [43.3206873, 43.3216077, -1.982756, -1.9816483],
  [37.1164015, 37.2074365, -6.9408515, -6.8243219],
  [42.1126512, 42.1158759, -0.4494181, -0.4437688],
  [38.6404498, 40.0945867, 1.1572738, 4.328026],
  [37.7243945, 37.7244945, -3.4755735, -3.4754735],
  [41.919034, 42.6442647, -3.1342714, -1.6787015],
  [27.9972565, 27.9973565, -15.4540603, -15.4539603],
  [42.2497202, 42.2500628, -8.6718948, -8.6714298],
  [41.6109923, 41.6139754, 0.6500168, 0.655644],
  [43.4411804, 43.4419187, -5.8005791, -5.7993954],
  [39.8846264, 41.1657381, -4.5790058, -3.0529852],
  [36.717813, 36.7210204, -4.4197019, -4.4123272],
  [37.3737743, 38.7550852, -2.3444114, -0.6471606],
  [41.9098937, 43.3149461, -2.4999443, -0.7233368],
  [200,200,200,200],//OURENSE, 34
  [41.8125745, 42.2417488, -5.0051044, -4.3708113],
  [42.3098144, 42.4386975, -8.9389063, -8.6519694],
  [40.7417785, 41.2462671, -6.1344988, -5.377138],
  [28.4476446, 28.5009633, -16.2690567, -16.1947423],
  [40.7994267, 41.1202758, -4.6182377, -4.0368669],
  [38.1073818, 38.1074818, -6.211688, -6.211588],
  [41.6157547, 41.8796922, -2.891375, -2.3982682],
  [40.9353152, 41.5826063, 0.6583708, 1.6530883],
  [40.351558, 40.3539085, -1.1063117, -1.1035863],
  [38.7776, 40.0456, -5.2252, -3.8931],
  [37.8438392, 40.7886312, -1.5289448, 0.6903174],
  [41.5231281, 41.9005062, -4.9527929, -4.3664332],
  [42.7477558, 42.7478558, -1.5563369, -1.5562369],
  [41.1171729, 42.0421081, -6.0588036, -5.2288732],
  [200,200,200,200],//ZARAGOZA, 49
  [2,2,2,2], //NINGUNA
];

Future<void> consigue_bounding_boxes() async {
  for (int i = 0; i < lista_provincias_peticiones.length -1; i++){
    if (i != 12 && i != 34 && i != 49){
      //lista_boundingboxes_provincias.add(await obtenerBoundingBoxProvincia(lista_provincias_peticiones[i]));
      print(lista_provincias_peticiones[i]);
      print(lista_boundingboxes_provincias[i]);
      print(await obtenerBoundingBoxProvincia(lista_provincias_peticiones[i]));
      print("-------------------------------------");
    }
  }
}
*/

Future<List<double>> obtenerBoundingBoxProvincia(String provincia) async {
  final url = 'https://nominatim.openstreetmap.org/search?format=json&state=$provincia&country=Spain&limit=1';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty && data.first['boundingbox'] != null) {
      List<String> boundingBoxStrings = data.first['boundingbox'].cast<String>();
      return boundingBoxStrings.map((coord) => double.parse(coord)).toList();
    } else {
      print(data.toString());
      throw Exception('Bounding box no encontrado para la provincia de $provincia');
    }
  } else {
    throw Exception('Error al obtener el bounding box para la provincia de $provincia');
  }
}

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
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black,
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
                                backgroundColor: const Color.fromARGB(
                                    255, 0, 0, 0), // Color del botón
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
            ]
        ),
      ),
      )
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
     )
    )
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

  bool enableNFCWriting = false;
  String mensaje_escribir_nfc = "";
  bool escritura_acabada = false;

  void ajusta_valores_escritura(
      bool permitir_escritura, String contenido_escribir) {
    setState(() {
      this.enableNFCWriting = permitir_escritura;
      this.mensaje_escribir_nfc = contenido_escribir;
    });
  }

  @override
  Widget build(BuildContext context) {
    startNFCSessionWriting(
        enableNFCWriting, this.id_objeto, context, ajusta_valores_escritura);

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
                                  color: Colors.black,
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
                                    backgroundColor: Colors.black,
                                  ),
                                  child: Text('Ver ubicación de pérdida'),
                                ),
                              )
                            : SizedBox(height: 0),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
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
                                      String url_usar =
                                          this.url_descarga_imagen;
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
                                          resultado_formulario
                                              .descripcion_objeto,
                                          this.perdido,
                                          Image.file(resultado_formulario
                                              .imagen_objeto),
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
                            ),
                            SizedBox(width: 5.5),
                            !this.perdido
                                ? Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          ajusta_valores_escritura(
                                              true, this.id_objeto);
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Acerque el dispositivo NFC para realizar su escritura',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator()
                                                    ]),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancelar'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      ajusta_valores_escritura(
                                                          false, "");
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        child: Column(
                                          children: [
                                            Icon(Icons.wifi),
                                            Text("Pasar a NFC")
                                          ],
                                        )),
                                  )
                                : SizedBox(width: 0),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            this.perdido
                                ? Expanded(
                                    child: ElevatedButton(
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
                                      borrar_objeto_conversaciones(this.id_objeto);
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
                                  ))
                                : Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              // Coloca aquí el widget de la nueva ventana
                                              // Puedes personalizarla como desees
                                              return MapSelector(
                                                  400);// lista_boundingboxes_provincias); // 400 metros de radio el circulo
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
                                        backgroundColor:
                                            Color.fromRGBO(255, 206, 59, 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(Icons.warning),
                                          Text("Perdido")
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 5.5),
                            Expanded(
                              child: ElevatedButton(
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
                            ),
                          ],
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
              )
            ]
        ),
      ),
      )
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
    )
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
  borrar_objeto_conversaciones(id_objeto);
}

void borrar_objeto_conversaciones(String id_objeto) async {
  var snapshot_objetos_conversaciones =  await FirebaseFirestore.instance
            .collection('objeto_conversaciones')
            .get();

  //Cojo los datos referidos a cada conversación registrada 
  for (var documento_conversacion in snapshot_objetos_conversaciones.docs) {

    //Para cada conversación borro el objeto eliminado (da igual que no esté contenido en la lista, no genera error)
    await FirebaseFirestore.instance
            .collection('objeto_conversaciones')
            .doc(documento_conversacion.id)
            .collection('lista_objetos')
            .doc(id_objeto)
            .delete();
  } 

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

Future<void> leer_objeto_concreto(
    String id_documento, context, Function callback_lectura_tarjeta_nfc) async {
  try {
    DocumentSnapshot documento = await FirebaseFirestore.instance
        .collection('objetos')
        .doc(id_documento)
        .get();
    if (!documento.exists){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('El objeto ya no se ha encuentra registrado')));
    }else if (!documento['"perdido"']){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('El objeto no está marcado como perdido')));
    }else {
      Map<String, dynamic> datos = documento.data() as Map<String, dynamic>;

      /// ABRIR CHAT
      await APIs.addChatUser(datos['"propietario"'], id_documento).then((value) async {
        if (value == 1) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('El objeto te pertenece')));
        } else if (value == 3) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('El usuario referenciado no existe')));
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
          callback_lectura_tarjeta_nfc(false, false);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  '¡Objeto encontrado!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                //content: Image.asset('assets/tick.png'),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: Text('Ir al chat del propietario',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(user: chatuser)));
                          callback_lectura_tarjeta_nfc(true, false);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
      });

    } 
  } catch (e) {
    print("Error al leer el objeto desde la base de datos: $e");
  }
}
