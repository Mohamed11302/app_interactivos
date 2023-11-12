import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:math'; 

class Formulario_Objeto extends StatefulWidget {

  String nombre_objeto;
  String descripcion_objeto;
  String url_imagen_objeto;

  Formulario_Objeto(this.nombre_objeto, this.descripcion_objeto, this.url_imagen_objeto) : super();

  @override
  _Formulario_Objeto createState() => _Formulario_Objeto(nombre_objeto, descripcion_objeto, this.url_imagen_objeto);
}

class _Formulario_Objeto extends State<Formulario_Objeto> {

  final String nombre_objeto;
  final String descripcion_objeto;
  final String url_imagen_objeto;

  _Formulario_Objeto(this.nombre_objeto, this.descripcion_objeto, this.url_imagen_objeto) : super();

  Resultado_Formulario datos_objeto = Resultado_Formulario("","",File(""), false);// Usamos XFile? para permitir que la imagen sea nula al principio.
  
  bool imagenSeleccionada = false; // Variable para rastrear si se ha seleccionado una imagen
  bool imagen_previa = false;
  final formKey = GlobalKey<FormState>();
  String nombre_aux = "";
  String descripcion_aux = "";
  
  @override
  void initState() {
    super.initState();
    if (this.url_imagen_objeto != ""){
      imagen_previa = true;
      establecer_imagen_previa();
    }
    nombre_aux = this.nombre_objeto;
    descripcion_aux = this.descripcion_objeto;
  }

  void establecer_imagen_previa() async{
    datos_objeto.imagen_objeto = await urlToFile(this.url_imagen_objeto);
  }

  @override
  Widget build(BuildContext context) {


    TextEditingController controlador_nombre = TextEditingController(text: nombre_aux);
    TextEditingController controlador_descripcion = TextEditingController(text: descripcion_aux);
    
   
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
              if ((imagenSeleccionada) || imagen_previa)
                Expanded(
                  child: (imagen_previa&&!imagenSeleccionada) ? Image.network(this.url_imagen_objeto) : Image.file(File(datos_objeto.imagen_objeto!.path)),
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        XFile? xfile_imagen_seleccionada = await seleccionarImagen(false);

                        if (xfile_imagen_seleccionada!=null){
                          datos_objeto.imagen_objeto = File(xfile_imagen_seleccionada.path);
                          setState(() {
                            imagenSeleccionada = true;
                            //if (imagen_previa){
                              imagen_previa = false;
                              datos_objeto.nueva_imagen = true;
                            //}

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
                        XFile? xfile_imagen_seleccionada = await seleccionarImagen(true);
                        
                        if (xfile_imagen_seleccionada!=null){
                          datos_objeto.imagen_objeto = File(xfile_imagen_seleccionada.path);
                          setState(() {
                            imagenSeleccionada = true;
                            imagen_previa = false;
                            datos_objeto.nueva_imagen = true;
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
                controller:  controlador_nombre,
                decoration: InputDecoration(labelText: "Nombre: "),
                onSaved: (value) {
                  datos_objeto.nombre_objeto = value!;
                },
                onChanged: (value) {
                  nombre_aux = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "El objeto nuevo debe tener un nombre";
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: controlador_descripcion,
                decoration: InputDecoration(labelText: "Descripción:"),
                onSaved: (value) {
                  datos_objeto.descripcion_objeto = value!;
                },
                onChanged: (value) {
                  descripcion_aux = value;
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
                  if (imagenSeleccionada || imagen_previa) {
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
  File imagen_objeto;
  bool nueva_imagen;

  Resultado_Formulario(this.nombre_objeto, this.descripcion_objeto, this.imagen_objeto, this.nueva_imagen) : super();
}

Future<File> urlToFile(String imageUrl) async {
  // generate random number.
  var rng = new Random();
  // get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
  // get temporary path from temporary directory.
  String tempPath = tempDir.path;
  // create a new file in temporary path with random file name.
  File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
  // call http.get method and pass imageUrl into it to get response.
  http.Response response = await http.get( Uri.parse(imageUrl));
  // write bodyBytes received in response to file.
  await file.writeAsBytes(response.bodyBytes);
  // now return the file which is created with random name in 
  // temporary directory and image bytes from response is written to // that file.
  return file;
}

