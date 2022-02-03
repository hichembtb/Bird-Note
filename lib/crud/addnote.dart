import 'dart:io';

import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bird_note/auth/home/homepage.dart';
import 'package:bird_note/compenents/alert.dart';
import 'package:bird_note/compenents/animation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
//
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Reference? ref;

  addNote(context) async {
    if (image == null) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        title: "Provid an image",
      ).show();
    }

    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      showLoading(context);
      formdata.save();
      await ref!.putFile(image!);
      imageUrl = await ref!.getDownloadURL();
      await notesref.add({
        "title": title,
        "note": note,
        "imageUrl": imageUrl,
        "userid": FirebaseAuth.instance.currentUser!.uid,
      }).then(
        (value) {
          Navigator.of(context).pushAndRemoveUntil(
              FadeAnimation(
                Page: HomePage(),
              ),
              (Route<dynamic> route) => false);
        },
      ).catchError(
        (error) {
          showDialog(
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
        },
      );
    }
  }

//
  var title, note;

//

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffe2e7ef),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Add Note"),
          toolbarHeight: 35,
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 8, right: 8),
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formstate,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.length > 22) {
                        return "less then 22 pls";
                      }
                      if (val.length < 2) {
                        return "more then 2";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      title = val;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(22),
                    ],
                    decoration: InputDecoration(
                      labelText: "Note",
                      suffixIcon: IconButton(
                        color: const Color(0xff073C47),
                        onPressed: () {
                          showBottomSheet(context);
                        },
                        icon: const Icon(Icons.add_a_photo),
                      ),
                      prefixIcon: const Icon(
                        Icons.note,
                        color: Color(0xff073C47),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.length > 250) {
                        return "less then 250 pls";
                      }
                      if (val.length < 2) {
                        return "more then 2";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      note = val;
                    },
                    maxLength: 250,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      prefixIcon: const Icon(
                        Icons.description,
                        color: Color(0xff073C47),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await addNote(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFF073C47),
                    child: const Text(
                      "Add Note",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Image(
              height: MediaQuery.of(context).size.height * 0.3,
              // color: Color(0xFF073C47),
              fit: BoxFit.fill,
              image: const AssetImage("images/addnote.png"),
            ),
          ],
        ),
      ),
    );
  }

  File? image;
  final imagePicker = ImagePicker();
  var imageUrl;

  cameraImage(context) async {
    var pickedimage = await imagePicker.getImage(source: ImageSource.camera);
    if (pickedimage != null) {
      image = File(pickedimage.path);
      var rand = Random().nextInt(1000);
      var imagename = "$rand" + basename(pickedimage.path);
      ref = FirebaseStorage.instance.ref("images").child(imagename);
      Navigator.of(context).pop();
    }
  }

  galleryImage(context) async {
    var pickedimage = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      image = File(pickedimage.path);
      var rand = Random().nextInt(1000);
      var imagename = "$rand" + basename(pickedimage.path);
      ref = FirebaseStorage.instance.ref("images").child(imagename);
      Navigator.of(context).pop();
    }
  }

  showBottomSheet(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Choose photo from",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await cameraImage(context);
              },
              icon: const Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: () async {
                await galleryImage(context);
              },
              icon: const Icon(Icons.image),
            )
          ],
        );
      },
    );
  }
}
