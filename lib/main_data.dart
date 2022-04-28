import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

final _auth = FirebaseAuth.instance;
final loggedInUser = _auth.currentUser!.uid;
final _firestore = FirebaseFirestore.instance;

String? email;
String? password;
bool showSpinner = false;
bool _validateEmail = false;
bool _validatePassword = false;
final _textEmail = TextEditingController();
final _textPassword = TextEditingController();
Map myMainData = {};
String? teacherNo;
String? booksNo;
String? theoreticalCourseNo;
String? labCourseNo;


class MainData extends StatefulWidget {
  final depID;
  final yearNo;
  final semesterID;

  const MainData({Key? key, this.semesterID, this.yearNo, this.depID})
      : super(key: key);

  @override
  _MainDataState createState() => _MainDataState();
}

class _MainDataState extends State<MainData> {
  Future getDocs() async {
    // print(widget.weekNo.toString());
    QuerySnapshot querySnapshot = await _firestore
        .collection("MainData")
        .where('depID', isEqualTo: widget.depID.toString())
        .where('yearNo', isEqualTo: int.parse(widget.yearNo))
        .where('semesterID', isEqualTo: widget.semesterID.toString())
        .get();

    var documentsMainData = querySnapshot.docs.first;
    setState(() {
      myMainData['MainDataID'] = documentsMainData['mainDataID'].toString();
      myMainData['DepID'] = documentsMainData['depID'].toString();
      myMainData['SemesterID'] = documentsMainData['semesterID'].toString();
      myMainData['YearNo'] = documentsMainData['yearNo'].toString();
      myMainData['TeachersNo'] = documentsMainData['teachersNo'].toString();
      myMainData['BooksNo'] = documentsMainData['booksNo'].toString();
      myMainData['TheoreticalCourseNo'] = documentsMainData['TheoreticalCourseNo'].toString();
      myMainData['LabCourseNo'] = documentsMainData['LabCourseNo'].toString();

      //print(myMainData['MainDataID'].toString());


      teacherNo = myMainData['TeachersNo'];
      booksNo = myMainData['BooksNo'];
      theoreticalCourseNo = myMainData['TheoreticalCourseNo'];
      labCourseNo = myMainData['LabCourseNo'];
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
    myMainData = {};
  }

  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
        "البيانات الأساسية",),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/cti.png'),
                // const Text(
                //   "شاشة الدخول الخاصة بمدققي الجودة",
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const Text(
                //   "البيانات الأساسية",
                //   style: TextStyle(
                //     fontSize: 35,
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        initialValue: teacherNo,
                        onChanged: (value) {
                          setState(() {
                              teacherNo = value;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 15,
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 15,
                          ),
                          errorText: _validatePassword ? 'حقل إجباري' : null,
                        ),
                      ),
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: widthOfScreen / 1.8,
                      child: const Text(
                        "عدد مدربي القسم ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        initialValue: booksNo,
                        onChanged: (value) {
                          setState(() {
                            booksNo = value;
                          });
                        },
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 20,
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          errorText: _validatePassword ? 'حقل إجباري' : null,
                        ),
                      ),
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 0,
                    ),
                    SizedBox(
                      width: widthOfScreen / 1.8,
                      child: const Text(
                        "عدد الحقائب التدريبية",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        initialValue: theoreticalCourseNo,
                        onChanged: (value) {
                          setState(() {
                            theoreticalCourseNo = value;
                          });
                        },
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 20,
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          errorText: _validatePassword ? 'حقل إجباري' : null,
                        ),
                      ),
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 0,
                    ),
                    SizedBox(
                      width: widthOfScreen / 1.8,
                      child: const Text(
                        "عدد الشعب النظري ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.top,
                        initialValue: labCourseNo,
                        onChanged: (value) {
                          setState(() {
                            labCourseNo = value;
                          });
                        },
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color(0xFF7D7D7D),
                            fontSize: 20,
                          ),
                          errorStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          errorText: _validatePassword ? 'حقل إجباري' : null,
                        ),
                      ),
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 0,
                    ),
                    SizedBox(
                      width: widthOfScreen / 1.8,
                      child: const Text(
                        "عدد الشعب العملي",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: widthOfScreen / 1.7,
                  height: heightOfScreen / 14,
                  decoration: BoxDecoration(
                    color: kColorButtonStyle,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                    _updateData(myMainData['MainDataID']);
                      print("Done");
                    },
                    child: const Text(
                      "حفظ",
                      style: kTextButtonStyle,
                    ),
                  ),
                ),
                // Container(
                //   width: widthOfScreen / 2,
                //   height: heightOfScreen / 10,
                //   decoration: BoxDecoration(
                //     color: Colors.green,
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: TextButton(
                //     onPressed: () => {
                //       Navigator.pop(context),
                //     },
                //     child: const Text(
                //       "رجوع",
                //       style: kTextButtonStyle,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Future<dynamic> _updateData(mainDataID) {
  Future<void> result;
    result = _firestore.collection('MainData').doc(mainDataID).update({
      'teachersNo': int.parse(teacherNo.toString()),
      'booksNo': int.parse(booksNo.toString()),
      'TheoreticalCourseNo': int.parse(theoreticalCourseNo.toString()),
      'LabCourseNo': int.parse(labCourseNo.toString()),
    });
  return result;
}