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
//               myTasksDynamic['TaskID'] = documentsTasks['taskID'].toString();
//               myTasksDynamic['TaskName'] = documentsTasks['taskName'].toString();
//         myTasksDynamic['TaskNote'] = documentsTasks['taskNote'].toString();
//       myTasksDynamic['TaskType'] = documentsTasks['taskType'].toString();
//     myTasksDynamic['TaskValue'] = documentsTasks['taskValue'].toString();
// myTasksDynamic['TaskResponsibleBy'] =
//     documentsTasks['responsibleBy'].toString();


final weeks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
//final attachedWith = ["booksNo","totalCourses"];


String depID = "pBvbTLAThETDzlD5oPlB"; //الحاسب الآلي
String semesterID = "dX0TSDlin7VVgVyIXAXa"; //الترم الاول
int yearNo = 2021;
int? valueWeeks;
String? taskID;
String? taskName;
String? taskNote;
int? taskType;
int? taskValue;
String? responsibleBy;
String taskAttachedWith = "";
String taskAttachment = "";


class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // @override
  // void initState() {
  //   super.initState();
  //
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/cti.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widthOfScreen / 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          iconSize: 36,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          isExpanded: true,
                          value: valueWeeks,
                          items: weeks.map(buildMenuItemWeeks).toList(),
                          onChanged: (value) {
                            setState(() => valueWeeks = value);
                            //print(value);
                            //print(getData);
                          },
                        ),
                      ),
                    ),
                  ),
                  const Text("الاسبوع", style: kTitleTextStyleSMregular,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthOfScreen / 2,
                    child: TextField(
                        onChanged: (value){
                          setState(() {
                            taskName = value;
                          });
                        },
                    ),
                  ),
                  const Text("عنوان المهمة", style: kTitleTextStyleSMregular,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthOfScreen / 2,
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          responsibleBy = value;
                        });
                      },
                    ),
                  ),
                  const Text("المسؤول", style: kTitleTextStyleSMregular,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthOfScreen / 2,
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          taskValue = int.parse(value);
                        });
                      },
                    ),
                  ),
                  const Text("التنفيذ", style: kTitleTextStyleSMregular,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthOfScreen / 2,
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          taskNote = value;
                        });
                      },
                    ),
                  ),
                  const Text("الملاحظات", style: kTitleTextStyleSMregular,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widthOfScreen / 2,
                    child: TextField(
                      onChanged: (value){
                        setState(() {
                          taskType = int.parse(value);
                        });
                      },
                    ),
                  ),
                  const Text("نسبة التنفيذ (0,1,2)", style: kTitleTextStyleSMregular,),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Button to Go Back To Search (week and semester)
              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                   // Navigator.pop(context);
                    _addData();
                    print("Done");
                    setState(() {
                      taskName = null;
                      responsibleBy = null;
                      taskValue = null;
                      taskNote = null;
                      taskType = null;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTask()));
                  },
                  child: const Text(
                    "حفظ",
                    style: kTextButtonStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> _addData() {

  DocumentReference<Map<String, dynamic>> document = _firestore.collection('Tasks').doc();

  Future<void> result = document.set({
    'taskID': document.id.toString(),
    'depID': depID,
    'semesterID': semesterID,
    'taskName': taskName,
    'taskNote': taskNote,
    'taskType': taskType,
    'taskValue': taskValue,
    'taskAttachedWith': taskAttachedWith,
    'taskAttachment': taskAttachment,
    'responsibleBy': responsibleBy,
    'weekNo': valueWeeks,
    'yearNo': yearNo,
  });
  print(document.id.toString());
  return result;
}

DropdownMenuItem<int> buildMenuItemWeeks(int item) => DropdownMenuItem(
  value: item,
  child: Text(
    item.toString(),
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
);
