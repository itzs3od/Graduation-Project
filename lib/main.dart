import 'package:cti_app/add_task.dart';
import 'package:cti_app/admin.dart';
import 'package:cti_app/admin_departments.dart';
import 'package:cti_app/admin_tasks.dart';
import 'package:cti_app/all_tasks.dart';
import 'package:cti_app/all_tasks1.dart';
import 'package:cti_app/main_data.dart';
import 'package:cti_app/report.dart';
import 'package:cti_app/tasks1.dart';
import 'package:cti_app/test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'add_department.dart';
import 'file_upload.dart';
import 'home.dart';
import 'login.dart';
import 'matiral_color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF127BB6)),
      ),
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}
