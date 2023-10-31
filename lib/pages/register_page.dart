import 'package:app_interactivos/pages/register_login.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app_interactivos/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_interactivos/global/common/toast.dart';
import 'package:app_interactivos/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String username_data = '';
  String user_email_data = '';
  String password_data = '';
  String password_confirmation_data = '';
  int age_data = 0;
  bool isSigningUp = false;
  bool _obscureText_password1 = true;
  bool _obscureText_password2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  FadeInUp(duration: Duration(milliseconds: 1300), child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 18),)),
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
                                      user_email_data = text;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Email or Phone number",
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
                                child: TextField(
                                  onChanged: (text){
                                    setState(() {
                                      username_data = text;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Username",
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
                                child: TextField(
                                  onChanged: (text){
                                    setState(() {
                                      age_data = int.parse(text);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Age",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                    
                                  ),
                                  keyboardType: TextInputType.number,
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
                                        obscureText: _obscureText_password1,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText_password1 = !_obscureText_password1;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText_password1 ? Icons.visibility : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
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
                                            password_confirmation_data = text;
                                          });
                                        },
                                        obscureText: _obscureText_password2,
                                        decoration: InputDecoration(
                                          hintText: "Confirm Password",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText_password2 = !_obscureText_password2;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText_password2 ? Icons.visibility : Icons.visibility_off,
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
                        FadeInUp(duration: Duration(milliseconds: 1500), child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterLogin()),
                                      (route) => false);
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.blue, fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                        ),
                        SizedBox(height: 50,),
                        FadeInUp(duration: Duration(milliseconds: 1500), child:
                        GestureDetector(
                          onTap:  (){
                            if (password_data == password_confirmation_data){
                              _signUp(username_data, user_email_data, password_data, age_data);

                            }
                            else{
                              showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('ERROR'),
                                                content: Text('The passwords do not match'),
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
                          child: Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.orange[900],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: isSigningUp ? CircularProgressIndicator(color: Colors.white,):Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            )),
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

  void _signUp(String username_data, String user_data, String password_data, int age_data) async {

setState(() {
  isSigningUp = true;
});

    String username = username_data;
    String user_email = user_data;
    String password = password_data;
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user_data, password: password_data);
    //User? register_user = await _auth.signUpWithEmailAndPassword(user, password);
    User? firebaseUser = userCredential.user;
    

setState(() {
  isSigningUp = false;
});
    if (firebaseUser != null) {
      showToast(message: "User is successfully created");
      await FirebaseFirestore.instance.collection('users').doc(user_email).set({
        'username': username,
        'user': user_email,
        'user_uid': firebaseUser.uid,
        'age': age_data
      });
      //Navigator.pushNamed(context, "/home");
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: user_email, password: password)));

    } else {
      showToast(message: "Some error happend");
    }
  }
}
