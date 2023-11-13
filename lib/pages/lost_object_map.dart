import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MapScreen extends StatefulWidget {
  
  final double centerLatitude; // Latitud del centro del círculo
  final double centerLongitude; // Longitud del centro del círculo
  final double radiusInMeters; // Radio del círculo en metros

  const MapScreen(this.centerLatitude, this.centerLongitude, this.radiusInMeters) : super();


  @override
  _MapScreen createState() => _MapScreen(centerLatitude, centerLongitude, radiusInMeters);
}

class _MapScreen extends State<MapScreen>{
  final double centerLatitude; // Latitud del centro del círculo
  final double centerLongitude; // Longitud del centro del círculo
  final double radiusInMeters; // Radio del círculo en metros
  late String info_localizacion; //Provincia, comunidad y pais
  bool lectura_info_localizacion_acabada = false;

  _MapScreen(this.centerLatitude, this.centerLongitude, this.radiusInMeters);


  @override
  void initState() {
    super.initState();
    // Este método se llama cuando el estado del widget es creado.
    // Puedes realizar inicializaciones aquí.
    recupera_info_localizacion();
  }

  // Función para calcular los puntos del círculo
  List<LatLng> calculateCirclePoints(int numberOfPoints) {
    final List<LatLng> points = [];

    for (int i = 0; i < numberOfPoints; i++) {
      final double angle = 2 * pi * i / numberOfPoints;
      final double x = centerLatitude + (radiusInMeters / 111195) * sin(angle);
      final double y = centerLongitude + (radiusInMeters / (111195 * cos(centerLatitude * pi / 180))) * cos(angle);

      points.add(LatLng(x, y));
    }

    return points;
  }

  void recupera_info_localizacion() async{

    setState(() {
      lectura_info_localizacion_acabada = false;
    });
  
    List<String> info= await obtener_Provincia_y_Pais(this.centerLatitude,this.centerLongitude);
    info_localizacion =  info[2]+", "+info[1]+", "+info[0];

    setState(() {
      lectura_info_localizacion_acabada = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final circlePoints = calculateCirclePoints(360);
    return Scaffold(
      appBar: AppBar(
        title: Text('Zona aproximada de la pérdida'),
        centerTitle: true, // Alinea el título verticalmente al centro
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0), // Ajusta la altura según tus necesidades
          child: !lectura_info_localizacion_acabada ? Center(child: CircularProgressIndicator()) :
            Center(
              child: Text(
                info_localizacion,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
        ),
      ),

      body: GestureDetector(
        onScaleUpdate: (details) {
          // Bloquea la interacción del usuario con el mapa
        },
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(centerLatitude, centerLongitude),
            zoom: 13.0, // Ajusta el nivel de zoom según tus preferencias
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
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
    );
  }
  
  
}

Future<List<String>> obtener_Provincia_y_Pais(double latitud, double longitud) async {
  final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitud&lon=$longitud';
  
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    //print(data['display_name'].toString());
    List<String> info_localizacion = data['display_name'].split(",");
    String pais = info_localizacion.last;
    String comunidad_autonoma = info_localizacion[info_localizacion.length-3];
    String provincia = info_localizacion[info_localizacion.length-4];
    return [pais,comunidad_autonoma,provincia];
  }else{  
  // Manejar errores o devolver un valor predeterminado si es necesario
    print("ERROR EN LA RESPUESTA HTTP CUANDO SE SOLICITABA INFORMACIÓN SOBRE LAS LOCALIZACIONES");
    return ["error"];
  }

}


    