import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bird_note/auth/login.dart';
import 'package:bird_note/compenents/alert.dart';
import 'package:bird_note/compenents/animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home/homepage.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var username;
  var email;
  var password;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  signUp() async {
    var formdata = formstate.currentState;
    if (formdata != null) {
      if (formdata.validate()) {
        formdata.save();
        try {
          showLoading(context);
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          return userCredential;
        } on FirebaseAuthException catch (e) {
          Navigator.of(context).pop();
          e.code == 'weak-password'
              ? AwesomeDialog(
                      width: double.infinity,
                      context: context,
                      title: "Error",
                      desc: 'The password provided is too weak.')
                  .show()
              : null;
          e.code == 'email-already-in-use'
              ? AwesomeDialog(
                  width: double.infinity,
                  context: context,
                  title: "Error",
                  desc: 'The account already exists for that email.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe2e7ef),
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Image(
              height: MediaQuery.of(context).size.height * 0.3,
              image: const AssetImage("images/splash.png"),
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
                      username = val;
                    },
                    validator: (val) {
                      if (val!.length > 15) {
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
                      hintText: "user name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      email = val;
                    },
                    validator: (val) {
                      if (val!.length > 25) {
                        return "Email too long";
                      }
                      if (val.length < 2) {
                        return "Email too short";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFe2f1ff),
                      prefixIcon: const Icon(Icons.mail),
                      hintText: "e-mail",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  TextFormField(
                    onSaved: (val) {
                      password = val;
                    },
                    validator: (val) {
                      if (val!.length > 15) {
                        return "Password too long";
                      }
                      if (val.length < 2) {
                        return "Password too short";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFe2f1ff),
                      prefixIcon: const Icon(
                        Icons.lock,
                      ),
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
                      const Text("already have an account  "),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            SlideLeft(
                              Page: Login(),
                            ),
                          );
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Color(0xFF073C47),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    // splashColor: Colors.deepOrange[900],
                    color: const Color(0xFF073C47),
                    onPressed: () async {
                      var response = await signUp();

                      if (response != null) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .add(
                          {
                            "username": username,
                            "email": email,
                          },
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
