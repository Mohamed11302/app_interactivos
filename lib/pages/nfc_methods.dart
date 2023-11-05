import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';



Future<void> startNFCSession(enableNFCReading,context) async {

    await NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) {
        try {

          if(enableNFCReading) {
            readNFC(tag,enableNFCReading,context);
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

  String readNFC(NfcTag? tag,enableNFCReading, context) {

    var payloadText = null;

    if (tag != null && enableNFCReading) {
      //quito los 3 primeros caracteres por ser unos añadidos en la lectura
      payloadText = (String.fromCharCodes(tag.data['ndef']['cachedMessage']['records'][0]['payload'])).substring(3);
      debugPrint('Payload of the NFC tag detected: $payloadText');


      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Información NFC: $payloadText'))
      );
    }
   return payloadText;
  }


