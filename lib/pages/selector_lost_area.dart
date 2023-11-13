import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapSelector extends StatefulWidget {
  final double initialRadius;

  MapSelector(this.initialRadius);

  @override
  _MapSelectorState createState() => _MapSelectorState(this.initialRadius);
}

class _MapSelectorState extends State<MapSelector> {
  double radiusInMeters;
  LatLng selectedLocation = LatLng(40.0, -4.0); // Coordenadas para España
  String info_localizacion = "";
  List<LatLng> circlePoints = [];
  bool info_actualizada = true;
  bool zona_correcta = true;

  List<String> lista_provincias_espana = [
    'Álava', 'Albacete', 'Alicante', 'Almería', 'Asturias', 'Ávila', 'Badajoz', 'Barcelona', 'Burgos', 'Cáceres', 'Cádiz', 'Cantabria',
    'Castellón', 'Ciudad Real', 'Córdoba', 'Cuenca', 'Gerona', 'Granada', 'Guadalajara', 'Guipúzcoa', 'Huelva', 'Huesca', 'Islas Balears',
    'Jaén', 'La Coruña', 'La Rioja', 'Las Palmas', 'León', 'Lérida', 'Lugo', 'Madrid', 'Málaga', 'Murcia', 'Navarra', 'Orense', 'Palencia',
    'Pontevedra', 'Salamanca', 'Santa Cruz de Tenerife', 'Segovia', 'Sevilla', 'Soria', 'Tarragona', 'Teruel', 'Toledo', 'Valencia',
    'Valladolid', 'Vizcaya', 'Zamora', 'Zaragoza', "<Ninguna>"
  ];
  String provincia_final = "";

  _MapSelectorState(this.radiusInMeters);

  @override
  void initState() {
    super.initState();
    radiusInMeters = widget.initialRadius;
    actualizar_info_punto_seleccionado();
  }

  String buscar_provincia(String a, String b) {
    for (int i = 0; i < lista_provincias_espana.length; i++) {
      
      if (lista_provincias_espana[i] == a) {
        return a;
      } else if (lista_provincias_espana[i] == b) {
        return b;
      }
    }
    return "";
  }

  void actualizar_info_punto_seleccionado() async {
    late bool zona_correcta_aux;
    setState(() {
      info_actualizada = false;
    });
    final info = await obtener_Provincia_y_Pais(selectedLocation.latitude, selectedLocation.longitude);
    if (info.length > 0) {
      info_localizacion = info[2] + ", " + info[1] + ", " + info[0];
      zona_correcta_aux = true;
    } else {
      info_localizacion = "Ubicación fuera de España";
      zona_correcta_aux = false;
    }
    setState(() {
      info_actualizada = true;
      zona_correcta = zona_correcta_aux;
    });
  }

  List<LatLng> calculateCirclePoints(int numberOfPoints) {
    final List<LatLng> points = [];

    for (int i = 0; i < numberOfPoints; i++) {
      final double angle = 2 * pi * i / numberOfPoints;
      final double x = selectedLocation.latitude + (radiusInMeters / 111195) * sin(angle);
      final double y = selectedLocation.longitude + (radiusInMeters / (111195 * cos(selectedLocation.latitude * pi / 180))) * cos(angle);

      points.add(LatLng(x, y));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el lugar de pérdida'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: selectedLocation,
                zoom: 6.0, // Nivel de zoom inicial
                onTap: (point) {
                  setState(() {
                    selectedLocation = point;
                    actualizar_info_punto_seleccionado();
                    this.circlePoints = calculateCirclePoints(360);
                  });
                },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: selectedLocation,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                PolylineLayerOptions(
                  polylines: [
                    Polyline(
                      points: circlePoints,
                      color: Colors.blue, // Puedes ajustar el color del círculo
                      strokeWidth: 2.0, // Puedes ajustar el ancho del círculo
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                info_actualizada
                    ? Text(
                        info_localizacion,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    : Center(child: CircularProgressIndicator()),
                SizedBox(height: 20.0),
                Text(
                  'Radio seleccionado: ${radiusInMeters.toStringAsFixed(2)} metros',
                  //style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Slider(
            value: radiusInMeters,
            onChanged: (value) {
              setState(() {
                this.radiusInMeters = value;
                this.circlePoints = calculateCirclePoints(360);
              });
            },
            min: 100.0, // Valor mínimo del radio
            max: 1000.0, // Valor máximo del radio
            divisions: 100, // Cantidad de divisiones
          ),
          ElevatedButton(
            onPressed: () {
              if (zona_correcta) {
                Navigator.of(context).pop({
                  'radius': radiusInMeters,
                  'location': selectedLocation,
                  'province': buscar_provincia(
                      info_localizacion.split(",")[1].substring(2),
                      info_localizacion.split(",")[0].substring(1))
                });
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Error",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        "Debes seleccionar una zona perteneciente a España.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("De acuerdo"),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Guardar ubicación'),
          ),
        ],
      ),
    );
  }
}

Future<List<String>> obtener_Provincia_y_Pais(
    double latitud, double longitud) async {
  final url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitud&lon=$longitud';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    try {
      List<String> info_localizacion = data['display_name'].split(",");
      String pais = info_localizacion.last;
      if (pais.substring(1) != "España") return [];
      String comunidad_autonoma = info_localizacion[info_localizacion.length - 3];
      String provincia = info_localizacion[info_localizacion.length - 4];
      return [pais, comunidad_autonoma, provincia];
    } catch (e) {
      return [];
    }
  } else {
    print(
        "ERROR EN LA RESPUESTA HTTP CUANDO SE SOLICITABA INFORMACIÓN SOBRE LAS LOCALIZACIONES");
    return ["error"];
  }
}
