import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(MaterialApp(
    builder: (context, child) {
      return Directionality(textDirection: TextDirection.ltr, child: child!);
    },
    title: 'CurvedNavBar',
    theme: ThemeData(
      primaryColor: Colors.grey[800],
    ),
    home: Example(),
  ));
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 0;
  bool showNFCTab = true; // Controla si mostrar la pestaña NFC o no
  late List<Widget Function()> _widgetOptions; // Definir _widgetOptions

  Future<void> _startNFCSession() async {
    await NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) {
        // Procesar la etiqueta NFC aquí y mostrar la información en _buildNFCTab()
        _buildNFCTab(tag);
        },
    );
  }

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
          () => _buildNFCTab(null), // Inicializa con un valor nulo
          () => Text(
        'CHATS',
        style: optionStyle,
      ),
    ];

    _startNFCSession();
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
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
          });
        },
      ),
    );
  }

  Widget _buildNFCTab(NfcTag? tag) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/gif_nfc.gif'),
        SizedBox(height: 16),
        Text(
          'Acerca el teléfono al dispositivo NFC',
          style: optionStyle,
        ),
        if (tag != null)
          Text(
            'Información NFC: ${tag.data}', // Personaliza cómo mostrar la información de la etiqueta
            style: optionStyle,
          ),
      ],
    );
  }
}
