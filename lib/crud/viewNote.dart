import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final notes;
  ViewNote({this.notes});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffe2e7ef),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My Note"),
        ),
        body: ListView(
          children: [
            Card(
              elevation: 5,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Image.network(
                "${widget.notes["imageUrl"]}",
                fit: BoxFit.fill,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: AutoSizeText(
                "${widget.notes["title"]}",
                maxLines: 1,
                maxFontSize: 30,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(
              endIndent: 100,
              indent: 100,
              color: Colors.black,
              thickness: 1.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 10.0,
              color: const Color(0xFF073C47).withOpacity(0.5),
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  "${widget.notes["note"]}",
                  style: Theme.of(context).textTheme.headline2,
                  textAlign: TextAlign.center,
                  maxFontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
