import 'package:bird_note/auth/login.dart';
import 'package:bird_note/compenents/animation.dart';
import 'package:bird_note/crud/addnote.dart';
import 'package:bird_note/crud/editNote.dart';
import 'package:bird_note/crud/viewNote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //

  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

  //

  //

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe2e7ef),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          Navigator.of(context).push(
            FadeAnimation(
              Page: AddNote(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 25.0,
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 35,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  AlignAnimation(
                    Page: Login(),
                  ),
                  (Route<dynamic> route) => false);
            },
            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
        title: const Text("Home Page"),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 12),
        child: FutureBuilder<QuerySnapshot>(
          future: notesRef
              .where("userid",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    background: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Icon(Icons.delete, color: Colors.red.shade900),
                        ),
                      ],
                    ),
                    onDismissed: (direction) async {
                      await notesRef
                          .doc(snapshot.data!.docs[index].id)
                          .delete();
                      await FirebaseStorage.instance
                          .refFromURL(snapshot.data!.docs[index]["imageUrl"])
                          .delete();
                    },
                    key: UniqueKey(),
                    child: ListNotes(
                      note: snapshot.data!.docs[index],
                      docid: snapshot.data!.docs[index].id,
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class ListNotes extends StatelessWidget {
  final note;
  final docid;
  ListNotes({this.note, this.docid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewNote(
              notes: note,
            ),
          ),
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(5),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${note["imageUrl"]}",
                fit: BoxFit.fill,
                height: 80,
              ),
            ),
            Expanded(
              flex: 2,
              child: ListTile(
                title: AutoSizeText(
                  "${note["title"]}",
                  maxLines: 1,
                ),
                subtitle: AutoSizeText(
                  "${note["note"]}",
                  maxLines: 1,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      FadeAnimation(
                        Page: EditNote(
                          docid: docid,
                          list: note,
                        ),
                      ),
                    );
                  },
                  icon: const FittedBox(
                    child: Icon(
                      Icons.edit,
                      color: Color(0xFF073C47),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
