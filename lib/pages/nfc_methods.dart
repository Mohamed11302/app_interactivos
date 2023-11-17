import 'package:app_interactivos/pages/database_methods.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';


Future<void> startNFCSessionReading(enableNFCReading,context, Function callback_lectura_tarjeta_nfc) async {

    await NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) {
        try {
          if(enableNFCReading) {
            
            var payloadText = null;
            //quito los 3 primeros caracteres por ser unos añadidos en la lectura
            payloadText = (String.fromCharCodes(tag.data['ndef']['cachedMessage']['records'][0]['payload'])).substring(3);
            leer_objeto_concreto(payloadText, context, callback_lectura_tarjeta_nfc);
          
          }
          return Future.value();
        }catch(error){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error mientras se manejaba una etiqueta nfc. $error'),
            ),
          );
          return Future.value();
        }
      },
    );

  }

void startNFCSessionWriting(bool enableNFCWriting, String cadena_escribir,context, Function ajusta_valores_escritura) async {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
      
        NdefMessage mensaje = NdefMessage([
          NdefRecord.createText(cadena_escribir),
        ]);

        try {
          
          if (enableNFCWriting && ndef != null){
            await ndef.write(mensaje);
            //NfcManager.instance.stopSession();
            ajusta_valores_escritura(false,"");
            Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Acerque el dispositivo NFC para realizar su escritura',
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    content: 
                      Row(
                        mainAxisAlignment:  MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 50.0,
                            ) 
                          ]
                      ),
                    actions: <Widget>[ 
                      TextButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          ajusta_valores_escritura(false, "");
                        },
                      ), 
                    ],
                  );
                },
              );
            Future.delayed(Duration(seconds: 1), () {
             Navigator.of(context).pop();
            });

            if (!ndef.isWritable) {
              NfcManager.instance.stopSession(errorMessage: 'La etiqueta no es sobreescribible');
              return;
            }
          }

        } catch (e) {
          NfcManager.instance.stopSession(errorMessage: e.toString());
          return;
        }
      }
    );
  }