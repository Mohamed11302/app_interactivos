import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> obtenerProvincia(double latitud, double longitud) async {
  final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitud&lon=$longitud';
  
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final address = data['address'];
    
    // Verifica si 'state' o 'province' está presente en la respuesta
    if (address.containsKey('state')) {
      return address['state'];
    } else if (address.containsKey('province')) {
      return address['province'];
    }
  }

  // Manejar errores o devolver un valor predeterminado si es necesario
  return 'Provincia no encontrada';
}

// Uso:
void main() async {
  double latitud = 40.4168;
  double longitud = -3.7038;

  String provincia = await obtenerProvincia(latitud, longitud);
  print('La ubicación se encuentra en la provincia de $provincia');
}
