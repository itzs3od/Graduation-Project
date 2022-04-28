import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/tasks1.dart';
import 'package:cti_app/tasks1.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'consts.dart';
import 'task_class.dart';

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;
final weeks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
final semesters = [1, 2, 3];
int? valueWeeks; //use for task
int? valueSemesters;
String? depID; //use for task
String? semesterID; //use for task
String thisYear = DateTime.now().year.toString(); //use for task
String? taskName;
var taskData = [];
bool showTasks = false;
bool checkboxValue = false;
TaskClass? newTask;
final Map myTasksDynamic = {};

class AllTasks extends StatefulWidget {
  final depID;
  final yearNo;
  final semesterID;
  final weekNo;

   const AllTasks({Key? key, this.depID, this.yearNo, this.semesterID, this.weekNo}) : super(key: key);

  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {

  Future getDocs() async {
    QuerySnapshot querySnapshot = await _firestore.collection("Tasks")
        .where('depID', isEqualTo: widget.depID.toString())
        .where('yearNo', isEqualTo: int.parse(widget.yearNo))
        .where('semesterID', isEqualTo: widget.semesterID.toString())
        .where('weekNo', isEqualTo: int.parse(widget.weekNo.toString()))
        .get();


    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var documentsTasks = querySnapshot.docs[i];
      myTasksDynamic['TaskName'+i.toString()] = documentsTasks['taskName'].toString();
      myTasksDynamic['TaskValue'+i.toString()] = documentsTasks['taskValue'].toString();
      myTasksDynamic['TaskType'+i.toString()] = documentsTasks['taskType'].toString();
       print(myTasksDynamic['TaskName'+i.toString()] + myTasksDynamic['TaskValue'+i.toString()] + myTasksDynamic['TaskType'+i.toString()]);
    }
  }

  @override
  initState(){
    super.initState();
    getDocs();
  }


  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/cti.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: SizedBox(
                height: heightOfScreen / 2,
                child: StreamBuilder<QuerySnapshot>(
                  // stream: _firestore
                  //     .collection('Tasks')
                  //     .where('depID', isEqualTo: "pBvbTLAThETDzlD5oPlB")
                  //     .where('yearNo', isEqualTo: 2021)
                  //     .where('semesterID', isEqualTo: "IFiotJOka9xrFhj0qrjK")
                  //     .where('weekNo', isEqualTo: 1)
                  //     .snapshots(),
                  stream: _firestore
                      .collection('Tasks')
                      .where('depID', isEqualTo: widget.depID.toString())
                      .where('yearNo', isEqualTo: int.parse(widget.yearNo))
                      .where('semesterID', isEqualTo: widget.semesterID.toString())
                      .where('weekNo', isEqualTo: int.parse(widget.weekNo.toString()))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Tasks.'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        newTask = TaskClass(
                            taskName: documents[index]['taskName'].toString(),
                            taskType: documents[index]['taskType'].toString(),
                            taskValue: documents[index]['taskValue'].toString(),
                        );

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            documents[index]['taskValue'].toString() == "0" ?
                            Checkbox(
                              onChanged: (bool? value) {
                                  value = checkboxValue;
                              },
                              value: checkboxValue,
                            ) : const SizedBox(
                              width: 50,
                              height: 50,
                              child: TextField(
                                onChanged: null,
                              ),
                            ),

                            Text(newTask!.taskName),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            //Text(newTask!.taskName),
            // Button to Go Back To Search (week and semester)
            Container(
              width: widthOfScreen / 2,
              height: heightOfScreen / 14,
              decoration: BoxDecoration(
                color: kColorButtonStyle,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Tasks1()));
                },
                child: const Text(
                  "العودة إلى صفحة البحث",
                  style: kTextButtonStyle,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
