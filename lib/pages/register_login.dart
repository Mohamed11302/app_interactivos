import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app_interactivos/pages/home_page.dart';
import 'package:app_interactivos/pages/register_page.dart';
import 'package:app_interactivos/pages/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterLogin extends StatefulWidget {
  const RegisterLogin({Key? key}) : super(key: key);

  @override
  _RegisterLoginState createState() => _RegisterLoginState();
}

class _RegisterLoginState extends State<RegisterLogin> {
  String user_data = '';
  String password_data = '';
  bool _obscureText = true;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(duration: Duration(milliseconds: 1000), child: Text("Findal", style: TextStyle(color: Colors.white, fontSize: 40),)),
                  SizedBox(height: 10,),
                  FadeInUp(duration: Duration(milliseconds: 1300), child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 18),)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                ),
                child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        FadeInUp(duration: Duration(milliseconds: 1400), child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10)
                            )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                ),
                                child: TextField(
                                  onChanged: (text){
                                    setState(() {
                                      user_data = text;
                                    });
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "Email or Phone number",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (text) {
                                          setState(() {
                                            password_data = text;
                                          });
                                        },
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )

                              
                            ],
                          ),
                        )),
                        SizedBox(height: 40,),
                        /*
                        FadeInUp(duration: Duration(milliseconds: 1500), child: MaterialButton(
                          onPressed: (){
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                  );
                          },
                          height: 30,
                          child: Center(
                            child: Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                          ),
                        )),
                        */
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              FadeInUp(duration: Duration(milliseconds: 1500), child:
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ForgotPasswordPage()),
                                        (route) => false);
                                  },
                                  child: Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                        color: Colors.grey, fontWeight: FontWeight.bold),
                                  )),),
                            ],
                          ),
                        SizedBox(height: 50,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeInUp(duration: Duration(milliseconds: 1800), child: MaterialButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegisterPage()),
                                  );
                                },
                                height: 50,
                                color: Colors.blue[500],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              )),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: FadeInUp(duration: Duration(milliseconds: 1900), child: MaterialButton(
                                onPressed: () async {
                                    try {
                                        final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: user_data,
                                          password: password_data,
                                        );

                                        if (userCredential.user != null) {
                                          // Credenciales válidas, navegar a la página del menú.
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => HomePage(user: user_data, password: password_data)),
                                          );
                                        } else {
                                          // Las credenciales no son válidas, puedes mostrar un mensaje al usuario.
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Credenciales incorrectas'),
                                                content: Text('El usuario o la contraseña no son válidos. Por favor, inténtelo de nuevo.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      } catch (e) {
                                        // Ocurrió un error al iniciar sesión con Firebase.
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Error de inicio de sesión'),
                                              content: Text('Ocurrió un error al iniciar sesión. Por favor, inténtelo de nuevo.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                },
                                height: 50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),

                                ),
                                color: Colors.orange[900],
                                child: Center(
                                  child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              )),
                            ),
                          ],
                        ),
                         SizedBox(height: 30,),  
                          FadeInUp(duration: Duration(milliseconds: 1500), child:GestureDetector(
                          onTap:  () async{
                                final user = await _signInWithGoogle();
                                if (user != null) {
                                  user_data = user.displayName.toString();
                                  password_data = "Unknown. Login with google";
                                  DocumentoDelUsuario(user.email.toString(), user_data, user.uid.toString());
                                  Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => HomePage(user: user_data, password: password_data)),
                                          );
                                } else {
                                  // Ocurrió un error en el registro
                                  print('Error en el registro con Google');
                                }
                          },
                          child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.orange[700],
                                borderRadius: BorderRadius.circular(10),
                              ),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                
                                children: <Widget>[
                                  Text(
                                    'Login with Google',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  Image.asset('assets/google_logo.png'),
                                ],
                              ),
                      ),
                          ),
                          ),
                          
                      ],
                    ),
                  ),
              ),
            )
          ],
        ),
      ),
    );

  }
  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      return authResult.user;
    } catch (error) {
      print(error);
      return null;
    }
  }
  Future<void> DocumentoDelUsuario(String user_data, String username_data, String user_uid_data) async {
    //Si no existe un documento en la collection users del usuario al logearse con google, se crea
    try {
      final collectionReference = FirebaseFirestore.instance.collection('users');
      final documentReference = collectionReference.doc(user_data);
      final documentSnapshot = await documentReference.get();

      if (documentSnapshot.exists) {
        //
      } else {
        // El documento no existe
        await documentReference.set({
          'age': 0,
          'user': user_data,
          'user_uid': user_uid_data,
          'username': username_data,
    });
      }
    } catch (e) {
      print('Error al verificar si el documento existe: $e');
    }
}


}
