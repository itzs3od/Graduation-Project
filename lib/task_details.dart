import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/add_task.dart';
import 'package:cti_app/file_upload.dart';
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
String? taskValue;
String? taskNote;
var taskAttachment;
bool editData = false;

class TaskDetails extends StatefulWidget {
  final taskID;

  const TaskDetails({Key? key, this.taskID}) : super(key: key);

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  Future getDocs() async {
    // print(widget.weekNo.toString());
    QuerySnapshot querySnapshot = await _firestore
        .collection("Tasks")
        .where('taskID', isEqualTo: widget.taskID.toString())
        .get();

    var documentsTasks = querySnapshot.docs.first;
    setState(() {
      myTasksDynamic['TaskID'] = documentsTasks['taskID'].toString();
      myTasksDynamic['TaskName'] = documentsTasks['taskName'].toString();
      myTasksDynamic['TaskNote'] = documentsTasks['taskNote'].toString();
      myTasksDynamic['TaskType'] = documentsTasks['taskType'].toString();
      myTasksDynamic['TaskValue'] = documentsTasks['taskValue'].toString();
      taskAttachment =
          documentsTasks['taskAttachment'].toString();
      myTasksDynamic['TaskResponsibleBy'] =
          documentsTasks['responsibleBy'].toString();

      print(myTasksDynamic['TaskID'].toString());
      print('type: '+ myTasksDynamic['TaskType']);

      if (myTasksDynamic['TaskType'].toString() == "0") {
        if (myTasksDynamic['TaskValue'].toString() == "0") {
          checkboxValue = false;
        } else {
          checkboxValue = true;
        }
        taskNote = myTasksDynamic['TaskNote'].toString();
      } else {
        taskValue = myTasksDynamic['TaskValue'].toString();
        taskNote = myTasksDynamic['TaskNote'].toString();
      }
    });
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
    editData = false;
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "تفاصيل المهمة",
        ),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child:  myTasksDynamic['TaskName'] == null ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset('assets/images/cti.png'),
              ),

              const Text(
                "عنوان المهمة",
                style: kTitleTextStyleSMbold,
              ),
              Text(
                myTasksDynamic['TaskName'].toString(),
                style: kTitleTextStyleSMregular,
              ),
              const Text(
                "المسؤول",
                style: kTitleTextStyleSMbold,
              ),
              Text(
                myTasksDynamic['TaskResponsibleBy'].toString(),
                style: kTitleTextStyleSMregular,
              ),
              const Text(
                "الملاحظات",
                style: kTitleTextStyleSMbold,
              ),


              editData
                  ? SizedBox(
                      width: widthOfScreen / 2,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                        initialValue: myTasksDynamic['TaskNote'].toString(),
                        onChanged: (value) {
                          setState(() {
                            myTasksDynamic['TaskNote'] = value;
                          });
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        myTasksDynamic['TaskNote'].toString().isEmpty
                            ? "لا توجد ملاحظات"
                            : myTasksDynamic['TaskNote'].toString(),
                        style: kTitleTextStyleSMregular,
                        textAlign: TextAlign.center,
                      ),
                    ),

              const Text(
                "التنفيذ",
                style: kTitleTextStyleSMbold,
              ),
              myTasksDynamic['TaskType'].toString() == "0"
                  ? Checkbox(
                      onChanged: editData
                          ? (value) {
                              setState(() {
                                checkboxValue = value;
                                // print(value);
                              });
                            }
                          : null,
                      value: checkboxValue,
                    )
                  : editData
                      ? SizedBox(
                          width: widthOfScreen / 6,
                          child: TextFormField(
                            style: kTitleTextStyleSMregular,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.top,
                            onChanged: (value) {
                              taskValue = value;
                            },
                            initialValue: taskValue,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                            ),
                          ),
                        )
                      : Text(
                          taskValue.toString(),
                          style: kTitleTextStyleSMregular,
                        ),

              const SizedBox(
                height: 8,
              ),

              // Button to go to attachments
              taskAttachment.toString().isNotEmpty
                  ? Container(
                      width: widthOfScreen / 1.7,
                      height: heightOfScreen / 14,
                      decoration: BoxDecoration(
                        color: kColorButtonStyle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FileUpload(
                                        taskID: widget.taskID,
                                      )));
                        },
                        child: const Text(
                          "الإنتقال إلى المرفقات",
                          style: kTextButtonStyle,
                        ),
                      ),
              ): editData ?
              Container(
                width: widthOfScreen / 1.7,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FileUpload(
                              taskID: widget.taskID,
                            )));
                  },
                  child: const Text(
                    "الإنتقال إلى المرفقات",
                    style: kTextButtonStyle,
                  ),
                ),
              ):
              const Text('لايوجد مرفقات', style: kTitleTextStyleSMregularErorr,),

              const SizedBox(
                height: 8,
              ),

              // Button to Edit Data
              Container(
                width: widthOfScreen / 1.7,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    // _updateData(myTasksDynamic['TaskID']);
                    setState(() {
                      editData = true;
                    });
                  },
                  child: const Text(
                    "تعديل",
                    style: kTextButtonStyle,
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // Button to Update Data
              Container(
                width: widthOfScreen / 1.7,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    _updateData(myTasksDynamic['TaskID']);
                    setState(() {
                      editData = false;
                    });
                    print("Done");
                  },
                  child: const Text(
                    "حفظ التعديلات",
                    style: kTextButtonStyle,
                  ),
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              // Button to Go Back To All Tasks
              // Container(
              //   width: widthOfScreen / 1.7,
              //   height: heightOfScreen / 14,
              //   decoration: BoxDecoration(
              //     color: kColorButtonStyle,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //     child: const Text(
              //       "العودة إلى صفحة المهام",
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

Future<dynamic> _updateData(taskID) {
  Future<void> result;
  if (myTasksDynamic['TaskType'].toString() == "0") {
    result = _firestore.collection('Tasks').doc(taskID).update({
      'taskValue': checkboxValue == false ? 0 : 1,
      'taskNote': myTasksDynamic['TaskNote'].toString(),
    });
  } else {
    result = _firestore.collection('Tasks').doc(taskID).update({
      'taskValue': int.parse(taskValue.toString()),
      'taskNote': myTasksDynamic['TaskNote'].toString(),
    });
  }
  return result;
}
