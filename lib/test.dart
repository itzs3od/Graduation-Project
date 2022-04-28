import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;

var documentsTasks;


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  Future getDocs() async {

    QuerySnapshot querySnapshot = await _firestore
        .collection("TasksAllDeptAllSemesters")
        .get();
    // QuerySnapshot querySnapshot = await _firestore
    //     .collection("Tasks")
    //     .get();

    print(querySnapshot.docs.length.toString());
    for (int i = 0; i < querySnapshot.docs.length; i++) {

      documentsTasks = querySnapshot.docs[i];
     //
     // DocumentReference<Map<String, dynamic>> document = _firestore.collection('TasksAllDeptAllSemesters').doc();
     //
     //   document.set({
     //    'taskID': document.id.toString(),
     //     'depID': documentsTasks['depID'].toString(),
     //     'semesterID': documentsTasks['semesterID'].toString(),
     //     'taskName': documentsTasks['taskName'].toString(),
     //    'taskNote': documentsTasks['taskNote'].toString(),
     //    'taskType': int.parse(documentsTasks['taskType'].toString()),
     //    'taskValue': int.parse(documentsTasks['taskValue'].toString()),
     //    'taskAttachedWith': documentsTasks['taskAttachedWith'].toString(),
     //    'taskAttachment': documentsTasks['taskAttachment'].toString(),
     //    'responsibleBy': documentsTasks['responsibleBy'].toString(),
     //    'weekNo': int.parse(documentsTasks['weekNo'].toString()),
     //    'yearNo': int.parse(documentsTasks['yearNo'].toString()),
     //  });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
