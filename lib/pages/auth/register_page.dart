import 'dart:convert';
import 'package:app_interactivos/pages/database_methods.dart';
import 'package:app_interactivos/pages/api/api.dart';
import 'package:app_interactivos/pages/auth/register_login.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:app_interactivos/pages/tabbed_window.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  final picker = ImagePicker();
  String username_data = '';
  String user_email_data = '';
  String password_data = '';
  String password_confirmation_data = '';
  int age_data = 0;
  bool isSigningUp = false;
  bool _obscureText_password1 = true;
  bool _obscureText_password2 = true;
  bool _isImagePickerActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 1200,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.orange.shade900,
            Colors.orange.shade800,
            Colors.orange.shade400
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeInUp(
                        duration: Duration(milliseconds: 1000),
                        child: Text(
                          "Findal",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10),
                                    )
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _image == null
                                        ? AssetImage(
                                                'assets/default_profile_picture.jpeg')
                                            as ImageProvider<Object>
                                        : FileImage(_image!),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: getImage,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.blue,
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                            duration: Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(225, 95, 27, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          user_email_data = text;
                                        });
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          labelText: "Email or Phone number",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          username_data = text;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Username",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  /*Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    /*child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          age_data = int.parse(text);
                                        });
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Age",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                      keyboardType: TextInputType.number,
                                    ),*/
                                    child: Column(
                                      children: [
                                        Text(
                                          "Profile Picture",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        if (_image != null)
                                          Image.file(
                                            _image!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        if (_image == null)
                                          ElevatedButton(
                                            onPressed: _getImageFromGallery,
                                            child: Text("Select from Gallery"),
                                          ),
                                        if (_image == null)
                                          ElevatedButton(
                                            onPressed: _getImageFromCamera,
                                            child: Text("Take a Photo"),
                                          ),
                                      ],
                                    ),
                                  ),*/
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
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
                                              labelText: "Password",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscureText_password1 =
                                                  !_obscureText_password1;
                                            });
                                          },
                                          icon: Icon(
                                            _obscureText_password1
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            onChanged: (text) {
                                              setState(() {
                                                password_confirmation_data =
                                                    text;
                                              });
                                            },
                                            obscureText: _obscureText_password2,
                                            decoration: InputDecoration(
                                              labelText: "Confirm Password",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscureText_password2 =
                                                  !_obscureText_password2;
                                            });
                                          },
                                          icon: Icon(
                                            _obscureText_password2
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: Row(
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
                                            builder: (context) =>
                                                RegisterLogin()),
                                        (route) => false);
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FadeInUp(
                          duration: Duration(milliseconds: 1500),
                          child: GestureDetector(
                            onTap: () async {
                              _signUp();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.orange[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                  child: isSigningUp
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (password_data == '' ||
        password_confirmation_data == '' ||
        username_data == '' ||
        user_email_data == '') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text('No puedes dejar en blanco los campos del registro'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (password_data != password_confirmation_data) {
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
    } else {
      _signUp_user();
      sendEmail(user_email_data, username_data);
    }
  }

  void _signUp_user() async {
    setState(() {
      isSigningUp = true;
    });
    print("------");
    print(_image.toString());
    if (_image == null) {
      _image = await getImageFileFromAssets();
      print(_image.toString());
    }
    String imagen = await subirImagen(_image!);
    try {
      await APIs.auth
          .createUserWithEmailAndPassword(
              email: user_email_data, password: password_data)
          .then((user) async {
        final us = user.user;
        if (us != null) {
          try {
            await us.updatePhotoURL(imagen);
            await us.updateDisplayName(username_data);
            await APIs.createUser(
                us.uid, username_data, user_email_data, imagen);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User is successfully created'),
              ),
            );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Example()));
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Some error happend ${e}'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error connecting with Firebase'),
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User is already in use'),
        ),
      );
    }

    setState(() {
      isSigningUp = false;
    });
  }

  Future sendEmail(
      String email_destinatario, String nombre_destinatario) async {
    final serviceId = 'service_lxzwz4s';
    final templateId = 'template_vzwrmos';
    final userId = 'IPa2bddutyh-9tPIC';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_subject': 'Register in FindAll App',
          'user_email': email_destinatario,
          'user_name': nombre_destinatario,
        }
      }),
    );
    print("----");
    print(response.body);
    print("----");
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<File> getImageFileFromAssets() async {
    final byteData =
        await rootBundle.load('assets/default_profile_picture.jpeg');

    final file = File(
        '${(await getTemporaryDirectory()).path}/default_profile_picture.jpeg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
