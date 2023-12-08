
import 'package:app_interactivos/pages/side_bar/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:app_interactivos/pages/app_bar.dart';

class AboutPage extends StatefulWidget {

  Function callback_boton_retroceso;
  AboutPage(this.callback_boton_retroceso) : super();
  @override
  State<AboutPage> createState() => _AboutPageState(callback_boton_retroceso);
}

class _AboutPageState extends State<AboutPage> {

  Function callback_boton_retroceso;

  _AboutPageState(this.callback_boton_retroceso);
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          
          this.callback_boton_retroceso();
          return true; // Cambia a false para bloquear el retroceso
        },
        child : GestureDetector(
          // for hiding keyboard
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: MyAppBarDrawer(),
              drawer: NavBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                    Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Acerca de',
                          style: TextStyle(
                            color: Colors.black, // Texto negro
                            fontSize: 30, // Ajusta el tamaño del texto
                            fontWeight:
                                FontWeight.bold, // Ajusta el peso del texto
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 1,
                          color: Colors.black26, // Línea divisoria
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Bienvenido a FindAll, la aplicación para encontrar objetos perdidos.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Funcionalidades:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: '1. Registra tu objeto: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      'Ingresa la información de tu objeto, aportando un nombre representativo, una descripción con los detalles principales y una fotografía en la que se distinga corrrectamente.',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: '2. Guarda los datos del objeto vía NFC: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      'Transfiere la información del objeto a una etiqueta "Near-Field Communication" utilizando la aplicación. Lo siguiente que debes hacer es colocar dicha etiqueta en una zona visible pero segura de él. Más tarde y en caso de perderlo, ¡otros usuarios podrán avisarte automáticamente si lo encuentran!',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: '3. Visualización de objetos perdidos: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      'Siempre que desees comprobar qué objetos han sido declarados por sus propietarios como extraviados, ¡basta con que selecciones la provincia española en la que te encuentras! ',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              children: [
                                TextSpan(
                                  text: '4. Hallazgo de un objeto: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      'Si te cruzas con alguno de los objetos anteriores, escanea su tarjeta NFC para redirigirte a un chat que permitirá la comunicación con el propietario real. Una vez dentro, podrás acordar su devolución a través de mensajes de texto e incluso fotografías, como ocurre en cualquier otra aplicación de mensajería',
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Proyecto:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Este es un proyecto desarrollado para la asignatura Diseño de Sistemas Interactivos perteneciente al 4º y último curso del grado de Ingeniería Informática en la universidad de Castilla-La Mancha (UCLM), en España. La idea de la que nació la aplicación fue la de hacer más fácil la interacción del usuario en algún aspecto cotidiano, así que decidimos centrarnos en la recuperación de bienes personales perdidos dentro del territorio nacional.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Desarrolladores:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Mohamed Essalhi Ahamyan',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Enrique Albalate Prieto',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            ),
        )
    );
  }
}
