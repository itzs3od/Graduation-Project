import 'package:cti_app/admin_departments.dart';
import 'package:cti_app/admin_tasks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;


class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
        title: const Text("صفحة مسؤول النظام"),
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
              const SizedBox(
                height: 14,
              ),

              // Button for Departments
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
                            builder: (BuildContext context) => const AdminDepartments()));
                  },
                  child: const Text(
                    "الاقسام",
                    style: kTextButtonStyle,
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // // Button for Tasks
              // Container(
              //   width: widthOfScreen / 2,
              //   height: heightOfScreen / 14,
              //   decoration: BoxDecoration(
              //     color: kColorButtonStyle,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: TextButton(
              //     onPressed: (){
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (BuildContext context) => AdminTasks()));
              //     },
              //     child: const Text(
              //       "المهام",
              //       style: kTextButtonStyle,
              //     ),
              //   ),
              // ),
              //
              // const SizedBox(
              //   height: 10,
              // ),
              //
              // // Button for Reports
              // Container(
              //   width: widthOfScreen / 2,
              //   height: heightOfScreen / 14,
              //   decoration: BoxDecoration(
              //     color: kColorButtonStyle,
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: const TextButton(
              //     onPressed: null,
              //     child: Text(
              //       "التقارير",
              //       style: kTextButtonStyle,
              //     ),
              //   ),
              // ),
              //
              // const SizedBox(
              //   height: 10,
              // ),

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
            ],
          ),
        ),
      ),
    );
  }
}
