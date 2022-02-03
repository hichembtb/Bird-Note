import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bird_note/auth/home/homepage.dart';
import 'package:bird_note/auth/signup.dart';
import 'package:bird_note/compenents/alert.dart';
import 'package:bird_note/compenents/animation.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //

  //
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  //
  //

  var myemail;
  var mypassword;
  //
  logIn() async {
    var formdata = formstate.currentState;
    if (formdata != null) {
      if (formdata.validate()) {
        formdata.save();
        try {
          showLoading(context);
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: myemail,
            password: mypassword,
          );
          return userCredential;
        } on FirebaseAuthException catch (e) {
          Navigator.of(context).pop();
          e.code == 'user-not-found'
              ? AwesomeDialog(
                  context: context,
                  title: "Error",
                  desc: 'no user found for that email.',
                ).show()
              : null;

          e.code == 'wrong-password'
              ? AwesomeDialog(
                  context: context,
                  title: "Error",
                  desc: 'Wrong password provided for that user.',
                ).show()
              : null;
        } catch (e) {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Internet Problem "),
                content: Container(
                  height: 50,
                ),
              );
            },
          );
        }
      }
    }
  }

//

  //

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe2e7ef),
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 50),
        children: [
          const Center(
            child: Image(
              image: AssetImage("images/splash.png"),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (val) {
                      myemail = val;
                    },
                    validator: (val) {
                      if (val!.length > 25) {
                        return "User Name too long";
                      }
                      if (val.length < 2) {
                        return "User name too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFe2f1ff),
                      prefixIcon: const Icon(Icons.person),
                      hintText: "user Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onSaved: (val) {
                      mypassword = val;
                    },
                    validator: (val) {
                      if (val!.length > 15) {
                        return "Password Name too long";
                      }
                      if (val.length < 2) {
                        return "Password name too short";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFe2f1ff),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: "password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("dont have an account? "),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            SlideRight(
                              Page: Signup(),
                            ),
                          );
                        },
                        child: const Text(
                          "Create one",
                          style: TextStyle(
                            color: Color(0xFF073C47),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // splashColor: Colors.deepOrange[900],
                    color: const Color(0xFF073C47),
                    onPressed: () async {
                      var user = await logIn();
                      user != null
                          ? Navigator.of(context).pushAndRemoveUntil(
                              AlignAnimationLog(
                                Page: HomePage(),
                              ),
                              (Route<dynamic> route) => false)
                          : null;
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
