import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/all_tasks1.dart';
import 'package:cti_app/test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'all_tasks.dart';
import 'consts.dart';
import 'login.dart';
import 'main_data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Alignment, Row, Border;

import "package:universal_html/html.dart" show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;
final years = [
  int.parse(DateTime.now().year.toString()),
  int.parse(DateTime.now().year.toString()) - 1,
  int.parse(DateTime.now().year.toString()) - 2,
  int.parse(DateTime.now().year.toString()) - 3,
  int.parse(DateTime.now().year.toString()) - 4
];
final semesters = [1, 2, 3];
// int? valueYears; //use for task
// int? valueSemesters;
String? depID; //use for task
String? semesterID; //use for task
String thisYear = DateTime.now().year.toString(); //use for task
String? taskName;
var taskData = [];
bool showTasks = false;
Map myTasksDynamic = {};
double? countCheckbox;
double? countNumbers;
double? result;
int checkboxNo = 0;
int textFieldNo = 0;
int textFieldMinusNo = 0;
double resultNegative = 0;
double resultPositive = 0;
int count = 0;
int counterWeeks = 0;

class Result extends StatefulWidget {
  Result({Key? key, this.result, this.valueSemesters, this.valueYears})
      : super(key: key);

  String? result;
  int? valueSemesters;
  int? valueYears;

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future getDocs() async {
    double countTextField = 0;

    QuerySnapshot querySnapshotDep = await _firestore
        .collection("Departments")
        .where('UID', isEqualTo: loggedInUser.toString())
        .get();
    var documentDep = querySnapshotDep.docs.first;

    QuerySnapshot querySnapshotSem = await _firestore
        .collection("Semesters")
        .where('semesterNo', isEqualTo: widget.valueSemesters)
        .get();
    var documentSem = querySnapshotSem.docs.first;

    QuerySnapshot querySnapshotTask = await _firestore
        .collection("Tasks")
        .where('depID', isEqualTo: documentDep['depID'].toString())
        .where('yearNo', isEqualTo: widget.valueYears)
        .where('semesterID', isEqualTo: documentSem['semesterID'].toString())
        .orderBy('weekNo', descending: false).get();

    for (int i = 0; i < querySnapshotTask.docs.length; i++) {
      var documentsTasks = querySnapshotTask.docs[i];
      setState(() {
        count = querySnapshotTask.docs.length;
        myTasksDynamic['TaskID' + i.toString()] =
            documentsTasks['taskID'].toString();
        myTasksDynamic['TaskName' + i.toString()] =
            documentsTasks['taskName'].toString();
        myTasksDynamic['TaskValue' + i.toString()] =
            documentsTasks['taskValue'];
        myTasksDynamic['TaskType' + i.toString()] = documentsTasks['taskType'];
        myTasksDynamic['ResponsibleBy' + i.toString()] =
            documentsTasks['responsibleBy'].toString();
        myTasksDynamic['TaskNote' + i.toString()] =
            documentsTasks['taskNote'].toString();
        myTasksDynamic['TaskAttachment' + i.toString()] =
            documentsTasks['taskAttachment'].toString();
        myTasksDynamic['WeekNo' + i.toString()] =
            documentsTasks['weekNo'].toString();
      });
    }

    QuerySnapshot querySnapshotMainData = await _firestore
        .collection("MainData")
        .where('depID', isEqualTo: documentDep['depID'].toString())
        .where('yearNo', isEqualTo: widget.valueYears)
        .where('semesterID', isEqualTo: documentSem['semesterID'].toString())
        .get();
    var documentMainData = querySnapshotMainData.docs.first;
    var booksNo = documentMainData['booksNo'].toString();
    var totalCoursesNo = documentMainData['LabCourseNo'] +
        documentMainData['TheoreticalCourseNo'];

    //print(querySnapshotTask.docs.length);
    try {
      for (int i = 0; i < querySnapshotTask.docs.length; i++) {
        var documentsTasks = querySnapshotTask.docs[i];
        if (documentsTasks['taskType'].toString() == "0") //checkbox
        {
          if (documentsTasks['taskValue'].toString() == "1") {
            checkboxNo++;
          }
        } else if (documentsTasks['taskType'].toString() == "1") // -percentage
        {
          if (documentsTasks['taskAttachedWith'].toString() == 'totalCourses') {
            myTasksDynamic['TaskValueNegative' + i.toString()] = 1 -
                (int.parse(documentsTasks['taskValue'].toString()) /
                    int.parse(totalCoursesNo.toString()));
            resultNegative = resultNegative +
                double.parse(myTasksDynamic['TaskValueNegative' + i.toString()]
                    .toString());
          }
        } else {
          if (documentsTasks['taskAttachedWith'].toString() == 'totalCourses') {
            myTasksDynamic['TaskValuePositive' + i.toString()] =
                int.parse(documentsTasks['taskValue'].toString()) /
                    int.parse(totalCoursesNo.toString());
            resultPositive = resultPositive +
                myTasksDynamic['TaskValuePositive' + i.toString()];
          }
          if (documentsTasks['taskAttachedWith'].toString() == 'booksNo') {
            myTasksDynamic['TaskValuePositive' + i.toString()] =
                int.parse(documentsTasks['taskValue'].toString()) /
                    int.parse(booksNo.toString());
            resultPositive = resultPositive +
                myTasksDynamic['TaskValuePositive' + i.toString()];
          }
          // if (documentsTasks['taskAttachedWith'].toString() == 'booksNo') {
          //   double result2 = double.parse(documentsTasks['taskValue'].toString()) / double.parse(booksNo.toString());
          //   print('result2: '+ result2.toString());
          // }

        }
      }
    } catch (e) {
      print('error: ' + e.toString());
    }

    // print('countTextField: '+countTextField.toString());
    //
    // countCheckbox = checkboxNo / 33;
    // countNumbers = (resultNegative + resultPositive) / 18;
    // setState(() {
    //   result = ((countCheckbox! * 0.591) + (countNumbers! * 0.409)) * 100;
    // });
    //print('result: ' + result.toString().substring(0,4));
    // print('count: '+countCheckbox.toString());
    // print('result: ' + result.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDocs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    result = null;
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("صفحة النتيجة"),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: myTasksDynamic['WeekNo' + (count - 1).toString()] == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Image.asset('assets/images/cti.png'),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "معدل الإنجاز",
                          style: kTitleTextStyleSMbold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.result.toString(),
                          style: const TextStyle(fontSize: 22,),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.black),
                            child: DataTable(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  )),
                              columnSpacing: 30,
                              dataRowHeight: heightOfScreen / 11,
                              sortColumnIndex: 5,
                              sortAscending: true,
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Text(
                                    'رقم الاسبوع',
                                    style: kTitleTextStyleSMboldtb,
                                  ),
                                ),
                                DataColumn(label: VerticalDivider()),
                                DataColumn(
                                  label: Text(
                                    'عنوان المهمة',
                                    style: kTitleTextStyleSMboldtb,
                                  ),
                                ),
                                DataColumn(label: VerticalDivider()),
                                DataColumn(
                                  label: Text(
                                    'المسؤول',
                                    style: kTitleTextStyleSMboldtb,
                                  ),
                                ),
                                DataColumn(label: VerticalDivider()),
                                DataColumn(
                                  label: Text(
                                    'التنفيذ',
                                    style: kTitleTextStyleSMboldtb,
                                  ),
                                ),
                                DataColumn(label: VerticalDivider()),
                                DataColumn(
                                  label: Text(
                                    'الملاحظات',
                                    style: kTitleTextStyleSMboldtb,
                                  ),
                                ),
                                DataColumn(label: VerticalDivider()),
                                DataColumn(
                                  label: Text(
                                    'المرفقات',
                                    style: kTitleTextStyleSMboldtb,
                                  ),
                                ),
                              ],
                              rows: <DataRow>[
                                if (count >= 0)
                                  for (int index = 0; index < count; index++)
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(
                                          Text(
                                            myTasksDynamic[
                                                    'WeekNo' + index.toString()]
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const DataCell(VerticalDivider()),
                                        DataCell(
                                          Text(
                                            myTasksDynamic[
                                                    'TaskName' + index.toString()]
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const DataCell(VerticalDivider()),
                                        DataCell(
                                          Text(
                                            getTaskValue(
                                              myTasksDynamic['ResponsibleBy' +
                                                      index.toString()]
                                                  .toString(),
                                            ),
                                            // myTasksDynamic['TaskValue' + index.toString()].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const DataCell(VerticalDivider()),
                                        DataCell(
                                          Text(
                                            getTaskValue(
                                              myTasksDynamic['TaskValue' +
                                                      index.toString()]
                                                  .toString(),
                                            ),
                                            // myTasksDynamic['TaskValue' + index.toString()].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const DataCell(VerticalDivider()),
                                        DataCell(
                                          Text(
                                            getTaskValue(
                                              myTasksDynamic['TaskNote' +
                                                      index.toString()]
                                                  .toString().isNotEmpty ?   myTasksDynamic['TaskNote' +
                                                  index.toString()]
                                                  .toString() : "لاتوجد ملاحظات"
                                            ),
                                            // myTasksDynamic['TaskValue' + index.toString()].toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        const DataCell(VerticalDivider()),
                                        DataCell(
                                          IconButton(
                                            onPressed: () {
                                              if(myTasksDynamic['TaskAttachment' + index.toString()].toString().isNotEmpty)
                                                {
                                                  _launchURL(myTasksDynamic['TaskAttachment' + index.toString()].toString());
                                                }
                                              else
                                                {
                                                  null;
                                                }
                                            },
                                            icon:  myTasksDynamic['TaskAttachment' +
                                                index.toString()]
                                                .toString()
                                                .isNotEmpty ? const Icon(Icons.file_download) : const Icon(Icons.close),
                                          ),
                                          // Text(
                                          //   getTaskValue(myTasksDynamic['TaskAttachment' + index.toString()].toString(),),
                                          //   // myTasksDynamic['TaskValue' + index.toString()].toString(),
                                          //   style: const TextStyle(
                                          //     fontSize: 12,
                                          //   ),
                                          // ),
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // Button to Logout
                    Container(
                      width: widthOfScreen / 2,
                      height: heightOfScreen / 14,
                      decoration: BoxDecoration(
                        color: kColorButtonStyle,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _auth.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Login()));
                        },
                        child: const Text(
                          "تسجيل خروج",
                          style: kTextButtonStyle,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),

                    // Container(
                    //   width: widthOfScreen / 2,
                    //   height: heightOfScreen / 14,
                    //   decoration: BoxDecoration(
                    //     color: kColorButtonStyle,
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: const ElevatedButton(
                    //     child: Text('Create Excel'),
                    //     onPressed: createExcel,
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}

String getTaskValue(dynamic oldVal) {
  String? newVal;
  if (oldVal.toString() == "1") {
    newVal = 'تم التنفيذ';
  } else if (oldVal.toString() == "0") {
    newVal = 'لم يتم التنفيذ';
  } else {
    newVal = oldVal;
  }
  return newVal.toString();
}

DropdownMenuItem<int> buildMenuItemYears(int item) => DropdownMenuItem(
      value: item,
      child: Text(
        item.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );

DropdownMenuItem<int> buildMenuItemSemesters(int item) => DropdownMenuItem(
      value: item,
      child: Text(
        item.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );

// myTasksDynamic['TaskID' + i.toString()] =
// documentsTasks['taskID'].toString();
// myTasksDynamic['TaskName' + i.toString()] =
// documentsTasks['taskName'].toString();
// myTasksDynamic['TaskValue' + i.toString()] =
// documentsTasks['taskValue'];
// myTasksDynamic['TaskType' + i.toString()] =
// documentsTasks['taskType'];
// myTasksDynamic['ResponsibleBy' + i.toString()] =
// documentsTasks['responsibleBy'].toString();
// myTasksDynamic['TaskNote' + i.toString()] =
// documentsTasks['taskNote'].toString();
// myTasksDynamic['TaskAttachment' + i.toString()] =
// documentsTasks['taskAttachment'].toString();

Future<void> createExcel() async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  for (int i = 0; i < count; i++) {
    int initRow = 2;
    sheet.getRangeByName('H2').setText('الأسبوع');
    sheet.getRangeByName('G2').setText('المهمة');
    sheet.getRangeByName('J' + initRow.toString()).setText('المهمة');
    sheet.getRangeByName('F2').setText('المسؤول');
    sheet.getRangeByName('E2').setText('التنفيذ');
    sheet.getRangeByName('D2').setText('ملاحظات');
    sheet.getRangeByName('B2').setText('نسبة التنفيذ');
    sheet.getRangeByName('A2').setText('المرفقات');
    // sheet.getRangeByName('A1').setText(myTasksDynamic['TaskName' + i.toString()]);
  }
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();
  if (kIsWeb) {
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'Output.xlsx')
      ..click();
  } else {
    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName =
        Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}

showAlertDialogReport(BuildContext context) {
  // set up the buttons
  Widget Button = TextButton(
    child: const Text("موافق"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // Widget continueButton = const TextButton(
  //   child: Text("تأكيد"),
  //   onPressed:  null,
  // );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("تنبيه"),
    content: const Text("يجب إدخال السنة والفصل الدراسي"),
    actions: [
      Button,
      // continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<dynamic> _launchURL(String url) async {
  await canLaunch(url) ? await launch(url) : throw 'حدث خطأ ما.';
}
