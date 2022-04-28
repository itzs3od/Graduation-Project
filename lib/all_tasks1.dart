import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/task_details.dart';
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
bool? checkboxValue;
TaskClass? newTask;
Map myTasksDynamic = {};
int countOfMap = 0;

class AllTasks1 extends StatefulWidget {
  final depID;
  final yearNo;
  final semesterID;
  final weekNo;

  const AllTasks1(
      {Key? key, this.depID, this.yearNo, this.semesterID, this.weekNo})
      : super(key: key);

  @override
  _AllTasks1State createState() => _AllTasks1State();
}

class _AllTasks1State extends State<AllTasks1> {
  Future getDocs() async {
    // print(widget.weekNo.toString());
    QuerySnapshot querySnapshot = await _firestore
        .collection("Tasks")
        .where('depID', isEqualTo: widget.depID.toString())
        .where('yearNo', isEqualTo: int.parse(widget.yearNo))
        .where('semesterID', isEqualTo: widget.semesterID.toString())
        .where('weekNo', isEqualTo: int.parse(widget.weekNo.toString()))
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var documentsTasks = querySnapshot.docs[i];
      setState(() {
        countOfMap = querySnapshot.docs.length;
        myTasksDynamic['TaskID' + i.toString()] =
            documentsTasks['taskID'].toString();
        myTasksDynamic['TaskName' + i.toString()] =
            documentsTasks['taskName'].toString();
        myTasksDynamic['TaskValue' + i.toString()] =
            documentsTasks['taskValue'].toString();
        myTasksDynamic['TaskType' + i.toString()] =
            documentsTasks['taskType'].toString();
        // if(i <= countOfMap) {print(querySnapshot.docs.length);}
      });
    }
    print(querySnapshot.docs.length);
  }

  @override
  void initState() {
    super.initState();
    getDocs();
  }

  @override
  void dispose() {
    super.dispose();
    myTasksDynamic = {};
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "جميع المهام",
        ),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: myTasksDynamic['TaskName0'] == null ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset('assets/images/cti.png'),
              ),
              // if (countOfMap >= 0)
              //   for (int index = 0; index <= countOfMap; index++)
              //     Text(myTasksDynamic['TaskName' + index.toString()].toString()),
              // Text(index.toString()),
              //Text(myTasksDynamic['TaskName'+index.toString()].toString()),
              //Text(newTask!.taskName),


              Directionality(
                textDirection: TextDirection.rtl,
                child: DataTable(
                  dataRowHeight: heightOfScreen / 10.5,
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'عنوان المهمة',
                        style: kTitleTextStyleSMbold,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'المزيد',
                        style: kTitleTextStyleSMbold,
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    if (countOfMap >= 0)
                      for (int index = 0; index < countOfMap; index++)
                        DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                myTasksDynamic['TaskName' + index.toString()]
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskDetails(
                                              taskID: myTasksDynamic['TaskID' +
                                                      index.toString()]
                                                  .toString())));
                                },
                                icon: const Icon(
                                  Icons.more_vert,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),

              const SizedBox(
                height: 8,
              ),
              // Button to Go Back To Search (week and semester)
              // Container(
              //   width: widthOfScreen / 2,
              //   height: heightOfScreen / 14,
              //   decoration: BoxDecoration(
              //     color: kColorButtonStyle,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //       // Navigator.push(
              //       //     context,
              //       //     MaterialPageRoute(
              //       //         builder: (context) => const Tasks1()));
              //     },
              //     child: const Text(
              //       "العودة إلى صفحة البحث",
              //       style: kTextButtonStyle,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
