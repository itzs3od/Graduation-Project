import 'dart:math';

import 'package:cti_app/reset_password.dart';
import 'package:cti_app/tasks.dart';
import 'package:cti_app/tasks1.dart';
import 'package:flutter/material.dart';
import 'admin.dart';
import 'consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var widthOfScreen = MediaQuery.of(context).size.width;
    var heightOfScreen = MediaQuery.of(context).size.height;

    FirebaseAuth _auth = FirebaseAuth.instance;
    String? email;
    String? password;
    bool showSpinner = false;
    bool _validateEmail = false;
    bool _validatePassword = false;
    final _textEmail = TextEditingController();
    final _textPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل الدخول"),
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
                          fontSize: 16,
                        ),
                        errorText: _validateEmail ? 'حقل إجباري' : null,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      onChanged: (value) {
                        password = value;
                        //print(password);
                      },
                      textAlign: TextAlign.start,
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress,
                      // controller: _textPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF7D7D7D),
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFF7D7D7D),
                          fontSize: 20,
                        ),
                        hintText: 'كلمة المرور',
                        errorStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        errorText: _validatePassword ? 'حقل إجباري' : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetPassword()));
                      },
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(fontSize: 19, color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
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
                      print(email.toString() + password.toString());
                      try {
                        setState(() {
                          _textEmail.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                          _textPassword.text.isEmpty
                              ? _validatePassword = true
                              : _validatePassword = false;
                        });
                        if (email == null || password == null) {
                        } else {
                          setState(() {
                            showSpinner = true;
                          });
                          if (email.toString() == "admin@cti.gov.sa") {
                            final user = await _auth
                                .signInWithEmailAndPassword(
                                    email: email.toString(),
                                    password: password.toString())
                                .catchError((e) async {
                              await showAlertDialog(context, e);
                            });
                            //print(user);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Admin()));

                            setState(() {
                              showSpinner = false;
                            });
                          } else {
                            final user = await _auth
                                .signInWithEmailAndPassword(
                                    email: email.toString(),
                                    password: password.toString())
                                .catchError((e) async {
                              await showAlertDialog(context, e);
                            });
                            //print(user);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Tasks1()));

                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text(
                      "تسجيل دخول",
                      style: kTextButtonStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, var errorMessage) {
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

  switch (errorMessage) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      errorMessage = "Email already used. Go to login page.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      errorMessage = "Wrong email/password combination.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      errorMessage = "No user found with this email.";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      errorMessage = "User disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      errorMessage = "Too many requests to log into this account.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      errorMessage = "Server error, please try again later.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      errorMessage = "Email address is invalid.";
      break;
    default:
      errorMessage = "Login failed. Please try again.";
  }

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
