import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sunutaxi/AllScreens/mainscreen.dart';
import 'package:sunutaxi/AllScreens/registrationScreen.dart';
import 'package:sunutaxi/AllWidgets/progressDialog.dart';
import 'package:sunutaxi/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 65.0),
              Image(
                image: AssetImage("images/logo.jpg"),
                width: 120.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 65.0),
              Text(
                "Connecter comme chauffeur",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 65.0),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1.0),
                    TextField(
                      controller: passwordTextEditingController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "connecter",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      onPressed: () {
                        if (!emailTextEditingController.text.contains("@")) {
                          displayToastMessage(
                              "l'adresse email n'est pas correct", context);
                        } else if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "le password doit comporter plus de 6 caractères",
                              context);
                        } else {
                          loginUserAndPassword(context);
                        }
                      },
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RegistrationScreen.idScreen, (route) => false);
                },
                child: Text("pas de compte? click ici."),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginUserAndPassword(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "Authentification, attendez...");
        });
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error :" + errMsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) // user created
    {
      userRef
          .child(firebaseUser.uid)
          .once()
          .then((value) => (DataSnapshot snap) {
                if (snap.value != null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                  displayToastMessage("Vous etes bien connectés", context);
                } else {
                  Navigator.pop(context);
                  _firebaseAuth.signOut();
                  displayToastMessage("Vous n'avez pas de compte", context);
                }
              });
    } else {
      Navigator.pop(context);
      displayToastMessage("Erreur ne peut pas connecter", context);
    }
  }
}
