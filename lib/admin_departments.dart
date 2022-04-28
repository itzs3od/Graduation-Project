import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/admin_departments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_department.dart';
import 'admin_tasks.dart';
import 'consts.dart';
import 'login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
Map myTasksDynamic = {};
int countOfMap = 0;

class AdminDepartments extends StatefulWidget {
  const AdminDepartments({Key? key}) : super(key: key);

  @override
  _AdminDepartmentsState createState() => _AdminDepartmentsState();
}

class _AdminDepartmentsState extends State<AdminDepartments> {


  Future getDepartments() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Departments")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var documentsDepartments = querySnapshot.docs[i];
      setState(() {
        countOfMap = querySnapshot.docs.length;
        myTasksDynamic['UID' + i.toString()] =
            documentsDepartments['UID'].toString();
        myTasksDynamic['depID' + i.toString()] =
            documentsDepartments['depID'].toString();
        myTasksDynamic['depName' + i.toString()] =
            documentsDepartments['depName'].toString();
      });
    }
    print(querySnapshot.docs.length);
  }


  @override
  void initState() {
    super.initState();
    getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery
        .of(context)
        .size
        .width;
    var heightOfScreen = MediaQuery
        .of(context)
        .size
        .height;


    return Scaffold(
      appBar: AppBar(
        title: const Text("صفحة الأقسام"),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: myTasksDynamic['UID0'] == null ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset('assets/images/cti.png'),
              ),
              const SizedBox(
                height: 14,
              ),

              // Button for Add Department
              // Container(
              //   width: widthOfScreen / 2,
              //   height: heightOfScreen / 14,
              //   decoration: BoxDecoration(
              //     color: kColorButtonStyle,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const AddDepartment()));
              //     },
              //     child: const Text(
              //       "إضافة قسم جديد",
              //       style: kTextButtonStyle,
              //     ),
              //   ),
              // ),

              const SizedBox(
                height: 10,
              ),

              Directionality(
                textDirection: TextDirection.rtl,
                child: DataTable(
                  dataRowHeight: heightOfScreen / 10.5,
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'اسم القسم',
                        style: kTitleTextStyleSMbold,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'المهام',
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
                                myTasksDynamic['depName' + index.toString()]
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => AdminTasks(depID:myTasksDynamic['depID' + index.toString()].toString(),)));
                                },
                                icon: const Icon(
                                  Icons.assignment,
                                ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Future<dynamic> _deleteUser(userID) {
  Future<void> result;
  result = _firestore.collection('Departments').doc(userID).delete();
  print("Done");
  return result;
}

showAlertDialog(BuildContext context, String depName, String depID) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("إلغاء"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("تأكيد"),
    onPressed:  () async{
      await _deleteUser(depID).then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const AdminDepartments()));
      });
      
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("تنبيه"),
    content: Text(" هل تريد حذف القسم \n"+ depName.toString() +"؟ " ),
    actions: [
      cancelButton,
      continueButton,
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
