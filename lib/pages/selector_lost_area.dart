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
  String info_imprimir = "";
  late List<String> info_localizacion;
  List<LatLng> circlePoints = [];
  bool info_actualizada = true;
  bool zona_correcta = true;
  
  List<String> lista_provincias_peticiones = [
    'A Coruña', 'Araba/Álava', 'Albacete', 'Alacant / Alicante', 'Almería', 'Asturias / Asturies', 'Ávila', 'Badajoz', 'Barcelona', 'Burgos', 'Cáceres', 'Cádiz', 'Cantabria',
    'Castelló / Castellón', 'Ciudad Real', 'Córdoba', 'Cuenca', 'Girona', 'Granada', 'Guadalajara', 'Gipuzkoa', 'Huelva', 'Huesca', 'Illes Balears',
    'Jaén', 'La Rioja', 'Las Palmas', 'León', 'Lleida', 'Lugo', 'Madrid', 'Málaga', 'Región de Murcia', 'Navarra - Nafarroa', 'Ourense', 'Palencia',
    'Pontevedra', 'Salamanca', 'Santa Cruz de Tenerife', 'Segovia', 'Sevilla', 'Soria', 'Tarragona', 'Teruel', 'Toledo', 'València / Valencia',
    'Valladolid', 'Bizkaia', 'Zamora', 'Zaragoza', "<Ninguna>"
  ];


  final puntos_toledo = [
    LatLng(40.5538, -5.2252),
    LatLng(40.5538, -3.8931),
    LatLng(38.2858, -3.8931),
    LatLng(38.2858, -5.2252),
    LatLng(40.5538, -5.2252),
  ];

  _MapSelectorState(this.radiusInMeters);//, this.lista_boundingboxes_provincias);

  @override
  void initState() {
    super.initState();
    radiusInMeters = widget.initialRadius;
    actualizar_info_punto_seleccionado();
  }

  Future<String> buscar_provincia(List<String> info_punto, String comunidad) async {
    
    for (int i = 0; i < lista_provincias_peticiones.length; i++) {
      //Miro en toda la lista a ver si está el nombre de una provincia española
      //En caso de que esté se devuelve su nombre únicamente en castellano 
      if (info_punto.contains(lista_provincias_peticiones[i])) 
        return lista_provincias_peticiones[i];
    }

    if (comunidad == "Comunidad de Madrid")
      return "Madrid";
    else
      return "Toledo";
  }

  String buscar_comunidad(List<String> info_punto){

    //Siempre aparece en la ultima posición el pais, y luego en la penúltima o bien un codigo postal o
    // la comunidad autonoma del punto
    try{
      
      int codigo_postal = int.parse(info_punto[info_punto.length-2]);
      return info_punto[info_punto.length-3];
    }catch(e){
      return info_punto[info_punto.length-2];
    }
  }

  void actualizar_info_punto_seleccionado() async {

    late bool zona_correcta_aux;
    setState(() {
      info_actualizada = false;
    });

    this.info_localizacion = await obtener_informacion_ubicacion(selectedLocation.latitude, selectedLocation.longitude);

    if (info_localizacion.length > 0) {

      String comunidad = buscar_comunidad(this.info_localizacion);
      String provincia = await buscar_provincia(this.info_localizacion, comunidad);
      String zona_adicional = provincia != this.info_localizacion[this.info_localizacion.indexOf(comunidad)-1] ? 
         this.info_localizacion[this.info_localizacion.indexOf(comunidad)-1] 
         :
          this.info_localizacion[this.info_localizacion.indexOf(comunidad)-2];
      info_imprimir = provincia != comunidad ? 
                      zona_adicional + ", " + provincia  + ", " + comunidad 
                      :
                      zona_adicional + ", " + provincia; 
      zona_correcta_aux = true;

    } else {
      info_imprimir = "Ubicación fuera de España";
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
                        info_imprimir,
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
            onPressed: () async {
              if (zona_correcta) {
                Navigator.of(context).pop({
                  'radius': radiusInMeters,
                  'location': selectedLocation,
                  'province': await buscar_provincia(info_localizacion,  buscar_comunidad(this.info_localizacion)),
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

Future<List<String>> obtener_informacion_ubicacion(
    double latitud, double longitud) async {
  final url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitud&lon=$longitud';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    try {
      //print(data.toString());

      List<String> info_localizacion = data['display_name'].split(",");

      String pais = info_localizacion.last;
      if (pais.substring(1) != "España") return [];

      info_localizacion = info_localizacion.asMap().entries.map((entry) {
        int index = entry.key;
        String elemento = entry.value;
        return (index == 0) ? elemento : elemento.substring(1);
      }).toList();

      //print(info_localizacion);

      return info_localizacion;

    } catch (e) {
      return [];
    }
  } else {
    print(
        "ERROR EN LA RESPUESTA HTTP CUANDO SE SOLICITABA INFORMACIÓN SOBRE LAS LOCALIZACIONES");
    return ["error"];
  }
}
