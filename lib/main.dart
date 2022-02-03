import 'package:bird_note/auth/home/homepage.dart';
import 'package:bird_note/auth/login.dart';
import 'package:bird_note/auth/signup.dart';
import 'package:bird_note/crud/addnote.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//
late bool isLoged;
//
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff073C47),
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  var userloged = FirebaseAuth.instance.currentUser;
  userloged == null ? isLoged = false : isLoged = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF073C47),
          secondary: Color(0xFF073C47),
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => Signup(),
        "homepage": (context) => HomePage(),
        "addnote": (context) => AddNote(),
      },
      home: isLoged == true ? HomePage() : Login(),
    );
  }
}
