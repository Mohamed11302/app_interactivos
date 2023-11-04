import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:app_interactivos/pages/nfc_methods.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  bool enableNFCReading = false;
  int _selectedIndex = 0;
  bool showNFCTab = true; // Controla si mostrar la pestaña NFC o no
  late List<Widget Function()> _widgetOptions; // Definir _widgetOptions

  _ExampleState() {
    _widgetOptions = [
          () => Text(
        'OBJETOS REGISTRADOS',
        style: optionStyle,
      ),
          () => Text(
        'OBJETOS PERDIDOS',
        style: optionStyle,
      ),
          () => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('assets/gif_nfc.gif'), SizedBox(height: 16), Text('Acerca el teléfono al dispositivo NFC'),],),//buildNFCTab(null, enableNFCReading,null), // Inicializa con un valor nulo
          
          () => Text(
        'CHATS',
        style: optionStyle,
      ),
    ];

    
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    startNFCSession(enableNFCReading,context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 20,
        title: const Text('FindAll'),
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
          showNFCTab
              ? Column(
            children: [
              Icon(Icons.wifi, size: 30),
              Text('NFCs'),
            ],
          )
              : Container(),
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
            }else{
              enableNFCReading = false;
            }
          });
        },
      ),
    );
  }
}