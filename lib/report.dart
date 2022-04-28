import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/all_tasks1.dart';
import 'package:cti_app/result.dart';
import 'package:cti_app/test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
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

import 'mobile.dart';

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;
final years = [
  int.parse(DateTime.now().year.toString()),
  // int.parse(DateTime.now().year.toString()) - 1,
  // int.parse(DateTime.now().year.toString()) - 2,
  // int.parse(DateTime.now().year.toString()) - 3,
  // int.parse(DateTime.now().year.toString()) - 4
];
final semesters = [1, 2, 3];
int? valueYears; //use for task
int? valueSemesters;
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
bool flag = false;

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {


  Future getDocs() async {
    double countTextField = 0;

    setState(() {
      result = 0;
      countCheckbox = 0;
      countNumbers = 0;
      checkboxNo = 0;
      resultNegative = 0;
      resultPositive = 0;
    });

    QuerySnapshot querySnapshotDep = await _firestore
        .collection("Departments")
        .where('UID', isEqualTo: loggedInUser.toString())
        .get();
    var documentDep = querySnapshotDep.docs.first;

    QuerySnapshot querySnapshotSem = await _firestore
        .collection("Semesters")
        .where('semesterNo', isEqualTo: valueSemesters)
        .get();
    var documentSem = querySnapshotSem.docs.first;

    QuerySnapshot querySnapshotTask = await _firestore
        .collection("Tasks")
        .where('depID', isEqualTo: documentDep['depID'].toString())
        .where('yearNo', isEqualTo: valueYears)
        .where('semesterID', isEqualTo: documentSem['semesterID'].toString())
        .get();

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
        myTasksDynamic['TaskType' + i.toString()] =
        documentsTasks['taskType'];
        myTasksDynamic['ResponsibleBy' + i.toString()] =
            documentsTasks['responsibleBy'].toString();
        myTasksDynamic['TaskNote' + i.toString()] =
            documentsTasks['taskNote'].toString();
        myTasksDynamic['TaskAttachment' + i.toString()] =
            documentsTasks['taskAttachment'].toString();
      });
    }

    QuerySnapshot querySnapshotMainData = await _firestore
        .collection("MainData")
        .where('depID', isEqualTo: documentDep['depID'].toString())
        .where('yearNo', isEqualTo: valueYears)
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
        } else if (documentsTasks['taskType'].toString() ==
            "1") // -percentage
            {
          if (documentsTasks['taskAttachedWith'].toString() ==
              'totalCourses') {
            myTasksDynamic['TaskValueNegative' + i.toString()] = 1 -
                (int.parse(documentsTasks['taskValue'].toString()) /
                    int.parse(totalCoursesNo.toString()));
            resultNegative = resultNegative +
                double.parse(
                    myTasksDynamic['TaskValueNegative' + i.toString()]
                        .toString());
          }
        } else {
          if (documentsTasks['taskAttachedWith'].toString() ==
              'totalCourses') {
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
    countCheckbox = checkboxNo / 33;
    countNumbers = (resultNegative + resultPositive) / 18;
    setState(() {
      result = ((countCheckbox! * 0.591) + (countNumbers! * 0.409)) * 100;
    });
    //print('result: ' + result.toString().substring(0,4));
    // print('count: '+countCheckbox.toString());
    // print('result: ' + result.toString());
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flag = false;
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("صفحة التقارير"),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child:flag == true ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset('assets/images/cti.png'),
              ),
              //Year Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: widthOfScreen / 3,
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
                            menuMaxHeight: heightOfScreen / 3,
                            iconSize: 36,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                            isExpanded: true,
                            value: valueYears,
                            items: years.map(buildMenuItemYears).toList(),
                            onChanged: (value) {
                              setState(() => valueYears = value);
                              //print(value);
                              //print(getData);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "رقم السنة",
                      style: kTitleTextStyleSMbold,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              //Semester Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                            value: valueSemesters,
                            items:
                                semesters.map(buildMenuItemSemesters).toList(),
                            onChanged: (value) {
                              setState(() => valueSemesters = value);
                              //print(value);
                              //print(getData);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "رقم الفصل الدراسي",
                      style: kTitleTextStyleSMbold,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              const SizedBox(
                height: 14,
              ),


              // Button to Show Report
              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  // onPressed: _createPDF,
                  onPressed: () async {
                    if (valueSemesters != null && valueYears != null) {
                      setState(() {
                        flag = true;
                      });
                      await getDocs();
                     await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Result(valueSemesters:valueSemesters, valueYears:valueYears, result: result.toString().substring(0, 4),)));
                      setState(() {
                        flag = false;
                      });
                    } else {
                      showAlertDialogReport(context);
                    }
                  },
                  child: const Text(
                    "عرض التقرير",
                    style: kTextButtonStyle,
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
                            builder: (BuildContext context) => const Login()));
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

Future<void> _createPDF() async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  page.graphics.drawString('Welcom PDF',
      PdfStandardFont(PdfFontFamily.timesRoman,30));
  PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 20),
      cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

  grid.columns.add(count: 7);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'a';
  header.cells[1].value = 'b';
  header.cells[2].value = 'c';
  header.cells[3].value = 'd';
  header.cells[4].value = 'e';
  header.cells[5].value = 'f';
  header.cells[6].value = 'g';

  PdfGridRow row = grid.rows.add();
  row.cells[0].value = 'test 7';
  row.cells[1].value = 'test 6';
  row.cells[2].value = 'test 5';
  row.cells[3].value = 'test 4';
  row.cells[4].value = 'test 3';
  row.cells[5].value = 'test 2';
  row.cells[6].value = 'test 1';


  row = grid.rows.add();
  row.cells[0].value = 't 7';
  row.cells[1].value = 't 6';
  row.cells[2].value = 't 5';
  row.cells[3].value = 't 4';
  row.cells[4].value = 't 3';
  row.cells[5].value = 't 2';
  row.cells[6].value = 't 1';

  grid.draw(
      page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));


  List<int> bytes = document.save();
  document.dispose();
  saveAndlaunchFile(bytes, 'Output.pdf');
}