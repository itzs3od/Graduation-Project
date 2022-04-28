import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cti_app/admin_departments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'consts.dart';
import 'login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
String ?email;
String ?password;
String ?depName;
bool showSpinner = false;
bool _validateEmail = false;
bool _validatePassword = false;
final _textEmail = TextEditingController();
final _textPassword = TextEditingController();
var userID;

class AddDepartment extends StatefulWidget {
  const AddDepartment({Key? key}) : super(key: key);

  @override
  _AddDepartmentState createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: const Text("إضافة قسم جديد"),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) {
                      depName = value;
                      //print(depName);
                    },
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.emailAddress,
                    // controller: _textEmail,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.insert_drive_file,
                        color: Color(0xFF7D7D7D),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF7D7D7D),
                        fontSize: 20,
                      ),
                      hintText: 'اسم القسم',
                      errorStyle: const TextStyle(
                        fontSize: 16,),
                      errorText:
                      _validateEmail ? 'حقل إجباري' : null,
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
                        fontSize: 16,),
                      errorText:
                      _validatePassword ? 'حقل إجباري' : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 28,
              ),

              // Button for Register
              Container(
                width: widthOfScreen / 2,
                height: heightOfScreen / 14,
                decoration: BoxDecoration(
                  color: kColorButtonStyle,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextButton(
                  onPressed: () async {
                    var user = await _auth.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
                    if(user.user!.uid != null)
                      {
                        setState(() {
                          userID = user.user!.uid;
                        });
                        if(userID.toString().isNotEmpty)
                          {
                            await _addData(context);
                            Navigator.pop(context);
                          }
                      }

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AddDepartment()));
                  },
                  child: const Text(
                    "تسجيل",
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

Future<dynamic> _addData(BuildContext context) {

  DocumentReference<Map<String, dynamic>> document = _firestore.collection('Departments').doc();

  Future<void> result = document.set({
    'depID': document.id.toString(),
    'UID': userID.toString(),
    'depName': depName.toString(),
  });
  print('done');
  return result;
}
