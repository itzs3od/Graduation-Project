import 'dart:math';

import 'package:cti_app/tasks.dart';
import 'package:cti_app/tasks1.dart';
import 'package:flutter/material.dart';
import 'admin.dart';
import 'consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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

    FirebaseAuth _auth = FirebaseAuth.instance;
    String ?email;
    String ?password;
    bool showSpinner = false;
    bool _validateEmail = false;
    bool _validatePassword = false;
    final _textEmail = TextEditingController();
    final _textPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("استعادة كلمة المرور"),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Image.asset('assets/images/cti.png'),
                ),
                // const Text(
                //   "شاشة الدخول",
                //   textAlign: TextAlign.center,
                //   style: kTitleTextStyle,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                        //print(email);
                      },
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      // controller: _textEmail,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF7D7D7D),
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFF7D7D7D),
                          fontSize: 20,
                        ),
                        hintText: 'البريد الالكتروني',
                        errorStyle: const TextStyle(
                          fontSize: 16,),
                        errorText:
                        _validateEmail ? 'حقل إجباري' : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),

                Container(
                  width: widthOfScreen / 1.7,
                  height: heightOfScreen / 14,
                  decoration: BoxDecoration(
                    color: kColorButtonStyle,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      await _auth.sendPasswordResetEmail(email: email.toString()).catchError((e) async {
                        await showAlertDialog(context, e);
                      });
                    },
                    child: const Text("إرسال", style: kTextButtonStyle,),
                  ),
                ),
              ],
            ),
          ),
        ),)
      ,
    );
  }
}


showAlertDialog(BuildContext context, var errorMessage) {

  // set up the buttons
  Widget Button = TextButton(
    child: const Text("موافق"),
    onPressed:  () {
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
    content: Text(errorMessage.toString()),
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
