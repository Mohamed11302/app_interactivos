import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Formulario_Objeto extends StatefulWidget {
  @override
  _Formulario_Objeto createState() => _Formulario_Objeto();
}

class _Formulario_Objeto extends State<Formulario_Objeto> {

  Resultado_Formulario datos_objeto = Resultado_Formulario("","",null);// Usamos XFile? para permitir que la imagen sea nula al principio.
  bool imagenSeleccionada = false; // Variable para rastrear si se ha seleccionado una imagen

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de un nuevo objeto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text("Imagen:"),
              SizedBox(height: 20,),
              if (imagenSeleccionada && datos_objeto.imagen_objeto != null)
                Expanded(
                  child: Image.file(File(datos_objeto.imagen_objeto!.path)),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        datos_objeto.imagen_objeto = await seleccionarImagen(false);
                        if (datos_objeto.imagen_objeto != null) {
                          setState(() {
                            imagenSeleccionada = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: Row (
                        children: [
                          Icon(Icons.photo),
                          Expanded(
                            child: Text("Ver galería", textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        datos_objeto.imagen_objeto = await seleccionarImagen(true);
                        if (datos_objeto.imagen_objeto != null) {
                          setState(() {
                            imagenSeleccionada = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: Row (
                        children: [
                          Icon(Icons.camera_alt),
                          Expanded(
                            child: Text("Usar cámara", textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: "Nombre: "),
                onSaved: (value) {
                  datos_objeto.nombre_objeto = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "El objeto nuevo debe tener un nombre";
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: "Descripción:"),
                onSaved: (value) {
                  datos_objeto.descripcion_objeto = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "El objeto nuevo debe tener una descripción";
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text("Guardar datos"),
                onPressed: () {
                  if (imagenSeleccionada) {
                    validar_datos_nuevo_objeto(context);
                  } else {
                    // Muestra un mensaje de error si no se ha seleccionado una imagen.
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Error", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text("Debes seleccionar una imagen para el nuevo objeto."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<XFile?> seleccionarImagen(bool camara) async {
    final ImagePicker picker = ImagePicker();
    XFile? imagen = null;
    if  (camara) imagen = await picker.pickImage(source: ImageSource.camera);
    else imagen = await picker.pickImage(source: ImageSource.gallery);
    return imagen;
  }

  void validar_datos_nuevo_objeto(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // Aquí puedes hacer lo que desees con los datos guardados, por ejemplo, guardarlos en una base de datos.
      Navigator.of(context).pop(datos_objeto);
    }
  }
}

class Resultado_Formulario {

  String nombre_objeto;
  String descripcion_objeto;
  XFile? imagen_objeto;

  Resultado_Formulario(this.nombre_objeto, this.descripcion_objeto, this.imagen_objeto) : super();
}