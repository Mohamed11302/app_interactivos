import 'dart:developer';

import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/helper/chat_screen.dart';
import 'package:app_interactivos/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:app_interactivos/pages/nfc_methods.dart';
import 'package:app_interactivos/pages/database_methods.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool enableNFCReading = false;
  int _selectedIndex = 0;
  List<String> lista_provincias_espana = [
    'Álava',
    'Albacete',
    'Alicante',
    'Almería',
    'Asturias',
    'Ávila',
    'Badajoz',
    'Barcelona',
    'Burgos',
    'Cáceres',
    'Cádiz',
    'Cantabria',
    'Castellón',
    'Ciudad Real',
    'Córdoba',
    'Cuenca',
    'Gerona',
    'Granada',
    'Guadalajara',
    'Guipúzcoa',
    'Huelva',
    'Huesca',
    'Islas Balears',
    'Jaén',
    'La Coruña',
    'La Rioja',
    'Las Palmas',
    'León',
    'Lérida',
    'Lugo',
    'Madrid',
    'Málaga',
    'Murcia',
    'Navarra',
    'Orense',
    'Palencia',
    'Pontevedra',
    'Salamanca',
    'Santa Cruz de Tenerife',
    'Segovia',
    'Sevilla',
    'Soria',
    'Tarragona',
    'Teruel',
    'Toledo',
    'Valencia',
    'Valladolid',
    'Vizcaya',
    'Zamora',
    'Zaragoza',
    "<Ninguna>"
  ];
  String provincia_seleccionada = "<Ninguna>";
  bool lectura_objetos_perdidos_acabada = true;

  late List<Widget Function()> _widgetOptions;

  List<Objeto> lista_objetos_perdidos = [];

  void consigueObjetosPerdidos(String provincia) async {
    setState(() {
      lectura_objetos_perdidos_acabada = false;
    });

    lista_objetos_perdidos = await readObjetosPerdidos(provincia);

    setState(() {
      lectura_objetos_perdidos_acabada = true;
    });
  }

  _ExampleState() {
    _widgetOptions = [
      () => Text(
            'OBJETOS REGISTRADOS',
            style: optionStyle,
          ),
      () => Scaffold(
            appBar: AppBar(
              title: Text(
                'OBJETOS PERDIDOS',
                style: optionStyle,
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Provincia seleccionada: ",
                    ),
                    Container(
                      width: 200,
                      child: DropdownButtonFormField(
                        value: provincia_seleccionada,
                        items: lista_provincias_espana.map((name) {
                          return DropdownMenuItem(
                            child: Text(name),
                            value: name,
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            consigueObjetosPerdidos(value.toString());
                            provincia_seleccionada = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: !lectura_objetos_perdidos_acabada
                      ? Center(child: CircularProgressIndicator())
                      : ListadoObjetos(lista_objetos_perdidos),
                ),
              ],
            ),
          ),
      () => Scaffold(
            appBar: AppBar(
              title: Text(
                'ESCÁNER DE ETIQUETAS',
                style: optionStyle,
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/gif_nfc.gif'),
                SizedBox(height: 50),
                Text('Acerca el teléfono al dispositivo NFC'),
              ],
            ),
          ),
      () => HomeScreen(),
    ];
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    //startNFCSession(enableNFCReading, context);
    return Scaffold(
      drawer: NavigDrawer(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 20,
        title: Text(
          'FindAll',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(innerContext).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
                backgroundImage: NetworkImage(APIs.auth.currentUser!.photoURL
                    .toString())), // Reemplaza 'tu_ruta_de_imagen' con la ruta correcta
            onPressed: () {
              // Lógica que se ejecuta al presionar el botón de la imagen
              print('Botón de imagen presionado');
              //log(APIs.user.uid.toString());
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex](),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: <Widget>[
          Column(
            children: [
              Icon(LineIcons.home, size: 30),
              Text('Inicio'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.search, size: 30),
              Text('Buscar'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.wifi, size: 30),
              Text('NFCs'),
            ],
          ),
          Column(
            children: [
              Icon(Icons.contacts, size: 30),
              Text('Chats'),
            ],
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 2) {
              enableNFCReading = true;
            } else {
              enableNFCReading = false;
            }
          });
        },
      ),
    );
  }
}
