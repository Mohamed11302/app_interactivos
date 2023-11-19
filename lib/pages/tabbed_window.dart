import 'dart:developer';

//import 'package:app_interactivos/main.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/app_bar.dart';
//import 'package:app_interactivos/pages/chat/chat_screen.dart';
import 'package:app_interactivos/pages/chat_main.dart';
import 'package:app_interactivos/pages/new_object_form.dart';
import 'package:app_interactivos/pages/side_bar/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:app_interactivos/pages/nfc_methods.dart';
import 'package:app_interactivos/pages/database_methods.dart';
//import 'package:app_interactivos/pages/side_bar/side_menu.dart';

class Tabbed_Window extends StatefulWidget {
  Tabbed_Window({Key? key}) : super(key: key);

  @override
  _Tabbed_Window createState() => _Tabbed_Window();
}

class _Tabbed_Window extends State<Tabbed_Window> {
  @override
  void initState() {
    super.initState();
    consigueObjetosRegistrados();
  }

  String cuenta_usuario = APIs.auth.currentUser!.email.toString();
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
  bool lectura_objetos_registrados_usuario_acabada = false;
  bool registro_nuevo_objeto_acabado = true;

  late List<Widget Function()> _widgetOptions;

  List<Objeto_Perdido> lista_objetos_perdidos = [];
  List<Objeto_Registrado> lista_objetos_registrados_usuario = [];

  void consigueObjetosPerdidos(String provincia) async {
    setState(() {
      lectura_objetos_perdidos_acabada = false;
    });

    lista_objetos_perdidos = await readObjetosPerdidos(provincia);

    setState(() {
      lectura_objetos_perdidos_acabada = true;
    });
  }

  void consigueObjetosRegistrados() async {
    setState(() {
      lectura_objetos_registrados_usuario_acabada = false;
    });

    lista_objetos_registrados_usuario =
        await readObjetosRegistrados(cuenta_usuario, callback_borrar_objetos);

    setState(() {
      lectura_objetos_registrados_usuario_acabada = true;
    });
  }

  void callback_borrar_objetos() {
    consigueObjetosRegistrados();
    consigueObjetosPerdidos(provincia_seleccionada);
  }

  void callback_lectura_tarjeta_nfc(bool cambiar_tab, bool habilitar_nfc){
    setState(() {
      if (cambiar_tab)
        this._selectedIndex = 3; //se pasa a la pestaña de chats para evitar poder seguir leyendo nfcs 
      this.enableNFCReading = habilitar_nfc;
    });
  }

  _Tabbed_Window() {
    _widgetOptions = [
      () => Scaffold(
            appBar: AppBar(
              title: Text(
                'OBJETOS REGISTRADOS',
                style: optionStyle,
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            body: Column(children: [
              SizedBox(height: 32),
              Center(
                  child: Container(
                width: 150, // Ancho del botón al ancho completo
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), // Bordes redondeados
                  color: Colors.blue, // Color del rectángulo
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Formulario_Objeto("", "", "");
                        },
                      ),
                    ).then((resultado_formulario) async {
                      if (resultado_formulario != null) {
                        registro_nuevo_objeto_acabado = false;
                        await registrarObjeto(
                            resultado_formulario.nombre_objeto,
                            resultado_formulario.descripcion_objeto,
                            resultado_formulario.imagen_objeto,
                            cuenta_usuario);
                        registro_nuevo_objeto_acabado = true;
                        consigueObjetosRegistrados();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Color del botón
                  ),
                  child: Expanded(child: Row(
                    children: [
                      Icon(Icons.add), 
                      SizedBox(width: 10,),
                      Text('Añadir objeto'),
                    ],
                  ),
                  ),
                ),
              )),
              SizedBox(
                height: 32,
              ),
              Expanded(
                child: (lectura_objetos_registrados_usuario_acabada &&
                        registro_nuevo_objeto_acabado)
                    ? Listado_Objetos_Registrados(
                        lista_objetos_registrados_usuario)
                    : Center(child: CircularProgressIndicator()),
              ),
            ]),
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
                  child: lectura_objetos_perdidos_acabada
                      ? Listado_Objetos_Perdidos(lista_objetos_perdidos,
                          () => consigueObjetosPerdidos(provincia_seleccionada))
                      : Center(child: CircularProgressIndicator()),
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
      Text(
        'Acerca el teléfono al dispositivo NFC ...',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(height: 30,),
      Image.asset('assets/gif_nfc.gif'),
      SizedBox(height: 30,),
      Text(
        '¡Podrás contactar con el propietario ',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Text(
        'del objeto encontrado!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ],
  ),
),

      () => ChatMainScreen(),
    ];
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    try {
      startNFCSessionReading(enableNFCReading, context, callback_lectura_tarjeta_nfc);
    } catch (e) {
      log("Ha ocurrido un error con la lectura NFC");
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: MyAppBarDrawer(),
      drawer: NavBar(),
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
