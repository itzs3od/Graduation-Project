import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/admin_report.dart';
import 'package:cti_app/all_tasks1.dart';
import 'package:cti_app/report.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'all_tasks.dart';
import 'consts.dart';
import 'login.dart';
import 'main_data.dart';

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;
final weeks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
final semesters = [1, 2, 3];
int? valueWeeks; //use for task
int? valueSemesters;
// String? depID; //use for task
String? semesterID; //use for task
String thisYear = DateTime.now().year.toString(); //use for task
String? taskName;
var taskData = [];
bool showTasks = false;
String? departmentID;

class AdminTasks extends StatefulWidget {
  AdminTasks({Key? key, this.depID}) : super(key: key);

  var depID;

  @override
  _AdminTasksState createState() => _AdminTasksState();
}

class _AdminTasksState extends State<AdminTasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      departmentID = widget.depID.toString();
      print(departmentID);

  }
  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الرئيسية"),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Image.asset('assets/images/cti.png'),
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
              //Weeks Field
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
                            menuMaxHeight: heightOfScreen / 3,
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
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "رقم الاسبوع",
                      style: kTitleTextStyleSMbold,
                    ),
                  ],
                ),
              ),

              //Get Semester Data
              SizedBox(
                width: 0,
                height: 0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Semesters')
                      .where('semesterNo', isEqualTo: valueSemesters)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Semesters.'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        semesterID = documents[index].id;
                        // final userID = documents[index]['UID'];
                        // final depName = documents[index]['depName'];

                        return Container();
                      },
                    );
                  },
                ),
              ),

              // Get Department Data
              SizedBox(
                width: 0,
                height: 0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Departments')
                      .where('UID', isEqualTo: '')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No Department.'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        widget.depID = documents[index].id;

                        return Container();
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // print(semesterID.toString());
                      if (valueSemesters != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainData(
                                      depID: widget.depID,
                                      yearNo: thisYear,
                                      semesterID: semesterID,
                                    )));
                      }
                      else {
                        showAlertDialogMainData(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.article_rounded,
                            size: 36,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "البيانات الأساسية",
                            style: kTitleTextStyleSMregular,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (valueSemesters != null && valueWeeks != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllTasks1(
                                      depID: widget.depID,
                                      yearNo: thisYear,
                                      semesterID: semesterID,
                                      weekNo: valueWeeks,
                                    )));
                      }
                      else
                        {
                          showAlertDialogTasks(context);
                        }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 0.5),
                      ),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.assignment_turned_in,
                            size: 36,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "جميع المهام",
                            style: kTitleTextStyleSMregular,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 12.0,
              ),

              // Button to Show All Tasks
              // Container(
              //   width: widthOfScreen / 2,
              //   height: heightOfScreen / 14,
              //   decoration: BoxDecoration(
              //     color: kColorButtonStyle,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: TextButton(
              //     onPressed: () {
              //       //print("depID: "+depID.toString()+" year: "+thisYear.toString()+" semester: "+semesterID.toString()+" week: "+valueWeeks.toString());
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => AllTasks1(
              //                     depID: depID,
              //                     yearNo: thisYear,
              //                     semesterID: semesterID,
              //                     weekNo: valueWeeks,
              //                   )));
              //     },
              //     child: const Text(
              //       "إظهار جميع المهام",
              //       style: kTextButtonStyle,
              //     ),
              //   ),
              // ),


              // Button to go to report
              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AdminReport(depID: departmentID,)));
                  },
                  child: const Text(
                    "صفحة التقارير",
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


              // Get Tasks Data
              SizedBox(
                width: 0,
                height: 0,
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
                      .where('depID', isEqualTo: widget.depID)
                      .where('yearNo', isEqualTo: thisYear)
                      .where('semesterID', isEqualTo: semesterID)
                      .where('weekNo', isEqualTo: valueWeeks)
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
                        //depID = documents[index].id;
                        //final taskName = documents[index]['taskName'];
                        setState(() {
                          taskData = [
                            documents[index]['taskName'],
                            documents[index]['taskType'],
                            documents[index]['taskValue']
                          ];
                        });
                        return Container();
                      },
                    );
                  },
                ),
              ),

              Visibility(
                visible: showTasks,
                child: Text(taskData.toString()),
              ),
              //getTasks(depID, thisYear, semesterID, valueWeeks),

              //To Show Data
              // Text("Year: "+thisYear.toString()),
              // Text("Semester : "+semesterID.toString()),
              // Text("Week : "+valueWeeks.toString()),
              // Text("Dep : "+depID.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

// int? valueWeeks; //use for task.
// String? depID; //use for task.
// String? semesterID; //use for task.
// String thisYear = DateTime.now().year.toString();.

Widget getTasks(
    String? depID, String? thisYear, String? semesterID, int? valueWeeks) {
  return SizedBox(
    width: 0,
    height: 0,
    child: StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Tasks')
          .where('depID', isEqualTo: depID)
          .where('yearNo', isEqualTo: thisYear)
          .where('semesterID', isEqualTo: semesterID)
          .where('weekNo', isEqualTo: valueWeeks)
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
            //depID = documents[index].id;
            //final taskName = documents[index]['taskName'];
            taskData = [
              documents[index]['taskName'],
              documents[index]['taskType'],
              documents[index]['taskValue']
            ];
            return Container();
          },
        );
      },
    ),
  );
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


showAlertDialogMainData(BuildContext context) {
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
    content: const Text("يجب إدخال الفصل الدراسي"),
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

showAlertDialogTasks(BuildContext context) {
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
    content: const Text("يجب إدخال الفصل الدراسي والاسبوع"),
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