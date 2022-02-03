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

class EditNote extends StatefulWidget {
  final docid;
  final list;
  EditNote({this.docid, this.list});
  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
//
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Reference? ref;

  editeNote(context) async {
    var formdata = formstate.currentState;

    if (image == null) {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();

        await notesref.doc(widget.docid).update(
          {
            "title": title,
            "note": note,
          },
        ).then(
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
    } else {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        await ref!.putFile(image!);
        imageUrl = await ref!.getDownloadURL();
        await notesref.doc(widget.docid).update(
          {
            "title": title,
            "note": note,
            "imageUrl": imageUrl,
          },
        ).then(
          (value) {
            Navigator.of(context).pushReplacementNamed("homepage");
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
          title: const Text(
            "Edit Note",
          ),
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
                    initialValue: widget.list["title"],
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
                        icon: const Icon(Icons.add_a_photo_outlined),
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
                    initialValue: widget.list["note"],
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
                      await editeNote(context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color(0xFF073C47),
                    child: const Text(
                      "Edit Note",
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


/* await ref.putFile(image!);
        imageUrl  = await ref.getDownloadURL();
        */