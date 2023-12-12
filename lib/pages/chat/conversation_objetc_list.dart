
import 'package:app_interactivos/pages/database_methods.dart';
import 'package:flutter/material.dart';

class Listado_Objetos_Conversacion extends StatelessWidget {
  final List<Objeto_Perdido> objetos;

  Listado_Objetos_Conversacion(this.objetos);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange.shade400, Colors.orange.shade900],
            ),
          ),
        ),
        title: Text(
          'Objetos de la conversación',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily:
                'CustomFont', // Reemplaza 'CustomFont' con el nombre de tu fuente
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
                  height: 30,
                ),
          Expanded(
            child: 
            this.objetos.length > 0 ? SafeArea(
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
              :
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ 
                    Text('¡Todos los objetos de los que hablasteis',
                      style: TextStyle(fontSize: 20)),
                    Text('fueron eliminados o recuperados!',
                      style: TextStyle(fontSize: 20)),
                  ]
                ),
              ),
            ),
        ],
      ),
    );
  }
}
